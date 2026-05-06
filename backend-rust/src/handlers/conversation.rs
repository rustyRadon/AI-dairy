use crate::db::Database;
use crate::models::conversation::{Conversation, Message, CreateConversationRequest, CreateMessageRequest};
use crate::utils::jwt::Claims;
use crate::services::openai_service::OpenAiService;
use axum::{
    extract::{Path, State},
    http::StatusCode,
    response::Json,
    routing::{get, post},
    Router,
};
use mongodb::bson::{doc, oid::ObjectId};
use futures::stream::TryStreamExt;

pub fn conversation_router(db: Database) -> Router {
    Router::new()
        .route("/conversations", post(create_conversation).get(get_conversations))
        .route("/conversations/:id", get(get_conversation_messages))
        .route("/conversations/:id/messages", post(add_message))
        .with_state(db)
}

async fn create_conversation(
    State(db): State<Database>,
    claims: Claims,
    Json(payload): Json<CreateConversationRequest>,
) -> Result<Json<Conversation>, StatusCode> {
    let collection = db.inner.collection::<Conversation>("conversations");
    let user_id = ObjectId::parse_str(&claims.sub).map_err(|_| StatusCode::BAD_REQUEST)?;

    let now = chrono::Utc::now();
    let conversation = Conversation {
        id: None,
        user_id,
        title: payload.title.unwrap_or_else(|| "New Reflection".to_string()),
        created_at: now,
        updated_at: now,
    };

    let result = collection.insert_one(&conversation, None).await
        .map_err(|_| StatusCode::INTERNAL_SERVER_ERROR)?;
    
    let mut conversation = conversation;
    conversation.id = Some(result.inserted_id.as_object_id().unwrap());

    Ok(Json(conversation))
}

async fn get_conversations(
    State(db): State<Database>,
    claims: Claims,
) -> Result<Json<Vec<Conversation>>, StatusCode> {
    let collection = db.inner.collection::<Conversation>("conversations");
    let user_id = ObjectId::parse_str(&claims.sub).map_err(|_| StatusCode::BAD_REQUEST)?;

    let mut cursor = collection.find(doc! { "user_id": user_id }, None).await
        .map_err(|_| StatusCode::INTERNAL_SERVER_ERROR)?;

    let mut conversations = Vec::new();
    while let Some(conv) = cursor.try_next().await.map_err(|_| StatusCode::INTERNAL_SERVER_ERROR)? {
        conversations.push(conv);
    }

    Ok(Json(conversations))
}

async fn add_message(
    State(db): State<Database>,
    claims: Claims,
    Path(conv_id): Path<String>,
    Json(payload): Json<CreateMessageRequest>,
) -> Result<Json<Message>, StatusCode> {
    let msg_collection = db.inner.collection::<Message>("messages");
    let conv_oid = ObjectId::parse_str(&conv_id).map_err(|_| StatusCode::BAD_REQUEST)?;

    // 1. Save User Message
    let user_message = Message {
        id: None,
        conversation_id: conv_oid,
        sender: "user".to_string(),
        content: payload.content.clone(),
        created_at: chrono::Utc::now(),
    };

    msg_collection.insert_one(&user_message, None).await
        .map_err(|_| StatusCode::INTERNAL_SERVER_ERROR)?;

    // 2. Generate AI Response
    let api_key = std::env::var("OPENAI_API_KEY").map_err(|_| StatusCode::INTERNAL_SERVER_ERROR)?;
    let ai_service = OpenAiService::new(api_key);
    
    let ai_text = ai_service.generate_reply(&payload.content).await
        .map_err(|_| StatusCode::INTERNAL_SERVER_ERROR)?;

    // 3. Save AI Message
    let ai_message = Message {
        id: None,
        conversation_id: conv_oid,
        sender: "ai".to_string(),
        content: ai_text,
        created_at: chrono::Utc::now(),
    };

    msg_collection.insert_one(&ai_message, None).await
        .map_err(|_| StatusCode::INTERNAL_SERVER_ERROR)?;
    
    Ok(Json(ai_message))
}

async fn get_conversation_messages(
    State(db): State<Database>,
    _claims: Claims,
    Path(conv_id): Path<String>,
) -> Result<Json<Vec<Message>>, StatusCode> {
    let msg_collection = db.inner.collection::<Message>("messages");
    let conv_id = ObjectId::parse_str(&conv_id).map_err(|_| StatusCode::BAD_REQUEST)?;

    let mut cursor = msg_collection.find(doc! { "conversation_id": conv_id }, None).await
        .map_err(|_| StatusCode::INTERNAL_SERVER_ERROR)?;

    let mut messages = Vec::new();
    while let Some(msg) = cursor.try_next().await.map_err(|_| StatusCode::INTERNAL_SERVER_ERROR)? {
        messages.push(msg);
    }

    Ok(Json(messages))
}