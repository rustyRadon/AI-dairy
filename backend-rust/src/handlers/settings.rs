use axum::{response::Json, routing::{get, put}, Router};

pub fn settings_router() -> Router {
    Router::new().route("/settings", get(get_settings)).route("/settings", put(update_settings))
}

async fn get_settings() -> Json<&'static str> {
    Json("get settings placeholder")
}

async fn update_settings() -> Json<&'static str> {
    Json("update settings placeholder")
}
