use axum::{response::Json, routing::get, Router};
use serde::Serialize;

#[derive(Serialize)]
struct HealthResponse {
    ok: bool,
}

pub fn health_router() -> Router {
    Router::new().route("/health", get(handler))
}

async fn handler() -> Json<HealthResponse> {
    Json(HealthResponse { ok: true })
}
