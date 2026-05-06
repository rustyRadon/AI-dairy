use crate::db::Database;
use crate::models::user::{CreateUserRequest, LoginRequest, AuthResponse, User, UserInfo, UpdateUserRequest};
use crate::services::auth_service::{hash_password, verify_password};
use crate::utils::jwt::{encode_jwt, Claims};
use axum::{
    extract::State,
    http::StatusCode,
    response::Json,
    routing::{get, post, put},
    Router,
};
use mongodb::bson::{doc, oid::ObjectId};

pub fn auth_router(db: Database) -> Router {
    Router::new()
        .route("/auth/register", post(register))
        .route("/auth/login", post(login))
        .route("/auth/me", get(get_me))
        .route("/auth/me", put(update_me))
        .with_state(db)
}

async fn register(
    State(db): State<Database>,
    Json(payload): Json<CreateUserRequest>,
) -> Result<Json<AuthResponse>, StatusCode> {
    let users_collection = db.inner.collection::<User>("users");
    
    if let Ok(Some(_)) = users_collection
        .find_one(doc! { "email": &payload.email }, None)
        .await
    {
        return Err(StatusCode::CONFLICT);
    }

    let password_hash = hash_password(&payload.password)
        .map_err(|_| StatusCode::INTERNAL_SERVER_ERROR)?;

    let now = chrono::Utc::now();
    let user = User {
        id: None,
        email: payload.email.clone(),
        nickname: payload.nickname.unwrap_or_else(|| payload.email.split('@').next().unwrap_or("User").to_string()),
        password_hash,
        pin_hash: None,
        created_at: now,
        updated_at: now,
    };

    let insert_result = users_collection
        .insert_one(&user, None)
        .await
        .map_err(|_| StatusCode::INTERNAL_SERVER_ERROR)?;

    let user_id = insert_result.inserted_id.as_object_id().unwrap().to_hex();
    let secret = std::env::var("JWT_SECRET").map_err(|_| StatusCode::INTERNAL_SERVER_ERROR)?;
    
    let claims = Claims {
        sub: user_id,
        exp: (chrono::Utc::now() + chrono::Duration::days(7)).timestamp() as usize,
    };
    
    let token = encode_jwt(&secret, &claims).map_err(|_| StatusCode::INTERNAL_SERVER_ERROR)?;

    Ok(Json(AuthResponse {
        token,
        user: UserInfo::from(user),
    }))
}

async fn login(
    State(db): State<Database>,
    Json(payload): Json<LoginRequest>,
) -> Result<Json<AuthResponse>, StatusCode> {
    let users_collection = db.inner.collection::<User>("users");
    
    let user = users_collection
        .find_one(doc! { "email": &payload.email }, None)
        .await
        .map_err(|_| StatusCode::INTERNAL_SERVER_ERROR)?
        .ok_or(StatusCode::UNAUTHORIZED)?;

    let is_valid = verify_password(&payload.password, &user.password_hash)
        .map_err(|_| StatusCode::INTERNAL_SERVER_ERROR)?;

    if !is_valid {
        return Err(StatusCode::UNAUTHORIZED);
    }

    let user_id = user.id.map(|id| id.to_hex()).unwrap_or_default();
    let secret = std::env::var("JWT_SECRET").map_err(|_| StatusCode::INTERNAL_SERVER_ERROR)?;
    
    let claims = Claims {
        sub: user_id,
        exp: (chrono::Utc::now() + chrono::Duration::days(7)).timestamp() as usize,
    };
    
    let token = encode_jwt(&secret, &claims).map_err(|_| StatusCode::INTERNAL_SERVER_ERROR)?;

    Ok(Json(AuthResponse {
        token,
        user: UserInfo::from(user),
    }))
}

async fn get_me(
    State(db): State<Database>,
    claims: Claims,
) -> Result<Json<UserInfo>, StatusCode> {
    let users_collection = db.inner.collection::<User>("users");
    let obj_id = ObjectId::parse_str(&claims.sub).map_err(|_| StatusCode::BAD_REQUEST)?;

    let user = users_collection
        .find_one(doc! { "_id": obj_id }, None)
        .await
        .map_err(|_| StatusCode::INTERNAL_SERVER_ERROR)?
        .ok_or(StatusCode::NOT_FOUND)?;

    Ok(Json(UserInfo::from(user)))
}

async fn update_me(
    State(db): State<Database>,
    claims: Claims,
    Json(payload): Json<UpdateUserRequest>,
) -> Result<Json<UserInfo>, StatusCode> {
    let users_collection = db.inner.collection::<User>("users");
    let obj_id = ObjectId::parse_str(&claims.sub).map_err(|_| StatusCode::BAD_REQUEST)?;

    let mut update_doc = doc! {};
    if let Some(nick) = payload.nickname {
        update_doc.insert("nickname", nick);
    }
    if let Some(email) = payload.email {
        update_doc.insert("email", email);
    }

    if update_doc.is_empty() {
        return Err(StatusCode::BAD_REQUEST);
    }

    update_doc.insert("updated_at", chrono::Utc::now());

    users_collection
        .update_one(doc! { "_id": obj_id }, doc! { "$set": update_doc }, None)
        .await
        .map_err(|_| StatusCode::INTERNAL_SERVER_ERROR)?;

    let updated_user = users_collection
        .find_one(doc! { "_id": obj_id }, None)
        .await
        .map_err(|_| StatusCode::INTERNAL_SERVER_ERROR)?
        .ok_or(StatusCode::NOT_FOUND)?;

    Ok(Json(UserInfo::from(updated_user)))
}