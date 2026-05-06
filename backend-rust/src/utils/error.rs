use axum::http::StatusCode;
use axum::response::{IntoResponse, Response};
use serde::Serialize;

#[derive(Debug, Serialize)]
pub struct ErrorResponse {
    pub error: String,
}

impl ErrorResponse {
    pub fn new(message: impl Into<String>) -> Self {
        Self { error: message.into() }
    }
}

pub fn handle_error(message: String, status: StatusCode) -> Response {
    let body = serde_json::to_string(&ErrorResponse::new(message)).unwrap_or_default();
    (status, body).into_response()
}
