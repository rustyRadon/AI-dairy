use axum::{response::Json, routing::get, Router};

pub fn inbox_router() -> Router {
    Router::new().route("/inbox", get(get_inbox))
}

async fn get_inbox() -> Json<&'static str> {
    Json("inbox placeholder")
}
