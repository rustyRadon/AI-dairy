use crate::db::Database;
use crate::models::user::{CreateUserRequest, LoginRequest, AuthResponse, User, UserInfo};
use crate::services::auth_service::{hash_password, verify_password, generate_token};
use axum::{
    extract::State,
    http::StatusCode,
    response::Json,
    routing::{get, post, put},
    Router,
};
use mongodb::bson::doc;

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
    
    // Check if user already exists
    if let Ok(Some(_)) = users_collection
        .find_one(doc! { "email": &payload.email }, None)
        .await
    {
        return Err(StatusCode::CONFLICT);
    }

    // Hash password
    let password_hash = hash_password(&payload.password)
        .map_err(|_| StatusCode::INTERNAL_SERVER_ERROR)?;

    // Create user
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
    let token = generate_token(&user_id, "your_jwt_secret_here")
        .map_err(|_| StatusCode::INTERNAL_SERVER_ERROR)?;

    let auth_response = AuthResponse {
        token,
        user: UserInfo::from(user),
    };

    Ok(Json(auth_response))
}

async fn login(
    State(db): State<Database>,
    Json(payload): Json<LoginRequest>,
) -> Result<Json<AuthResponse>, StatusCode> {
    let users_collection = db.inner.collection::<User>("users");
    
    // Find user
    let user = users_collection
        .find_one(doc! { "email": &payload.email }, None)
        .await
        .map_err(|_| StatusCode::INTERNAL_SERVER_ERROR)?
        .ok_or(StatusCode::UNAUTHORIZED)?;

    // Verify password
    let is_valid = verify_password(&payload.password, &user.password_hash)
        .map_err(|_| StatusCode::INTERNAL_SERVER_ERROR)?;

    if !is_valid {
        return Err(StatusCode::UNAUTHORIZED);
    }

    let user_id = user.id.map(|id| id.to_hex()).unwrap_or_default();
    let token = generate_token(&user_id, "your_jwt_secret_here")
        .map_err(|_| StatusCode::INTERNAL_SERVER_ERROR)?;

    let auth_response = AuthResponse {
        token,
        user: UserInfo::from(user),
    };

    Ok(Json(auth_response))
}

async fn get_me(
    State(_db): State<Database>,
) -> Result<Json<UserInfo>, StatusCode> {
    // This would need JWT middleware to extract user info
    // For now, return a placeholder
    Err(StatusCode::NOT_IMPLEMENTED)
}

async fn update_me(
    State(_db): State<Database>,
) -> Result<Json<UserInfo>, StatusCode> {
    // This would need JWT middleware to extract user info
    // For now, return a placeholder
    Err(StatusCode::NOT_IMPLEMENTED)
}
