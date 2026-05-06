use axum::{response::Json, routing::{get, post, put, delete}, Router};

pub fn journal_router() -> Router {
    Router::new()
        .route("/journal/entries", post(create_entry))
        .route("/journal/entries", get(list_entries))
        .route("/journal/entries/:id", put(update_entry))
        .route("/journal/entries/:id", delete(delete_entry))
}

async fn create_entry() -> Json<&'static str> {
    Json("create journal entry placeholder")
}

async fn list_entries() -> Json<&'static str> {
    Json("list journal entries placeholder")
}

async fn update_entry() -> Json<&'static str> {
    Json("update journal entry placeholder")
}

async fn delete_entry() -> Json<&'static str> {
    Json("delete journal entry placeholder")
}
