use axum::{response::Json, routing::{get, post}, Router};

pub fn memory_router() -> Router {
    Router::new()
        .route("/memory/extract", post(extract_memory))
        .route("/memory/recall", get(recall_memory))
        .route("/memory/timeline", get(memory_timeline))
}

async fn extract_memory() -> Json<&'static str> {
    Json("extract memory placeholder")
}

async fn recall_memory() -> Json<&'static str> {
    Json("recall memory placeholder")
}

async fn memory_timeline() -> Json<&'static str> {
    Json("memory timeline placeholder")
}
