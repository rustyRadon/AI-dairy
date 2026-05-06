use axum::{response::Json, routing::get, Router};

pub fn streaks_router() -> Router {
    Router::new().route("/streaks", get(get_streaks))
}

async fn get_streaks() -> Json<&'static str> {
    Json("streaks placeholder")
}
