use crate::db::Database;
use axum::{response::Json, routing::{get, post}, Router};

pub fn conversation_router(_db: Database) -> Router {
    Router::new()
        .route("/conversations", post(create_conversation))
        .route("/conversations", get(list_conversations))
        .route("/conversations/:id", get(get_conversation))
        .route("/conversations/:id/messages", post(add_message))
}

async fn create_conversation() -> Json<&'static str> {
    Json("create conversation placeholder")
}

async fn list_conversations() -> Json<&'static str> {
    Json("list conversations placeholder")
}

async fn get_conversation() -> Json<&'static str> {
    Json("get conversation placeholder")
}

async fn add_message() -> Json<&'static str> {
    Json("add message placeholder")
}
