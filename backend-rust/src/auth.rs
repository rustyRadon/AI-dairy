use axum::{
    extract::{Request, State},
    http::{header, StatusCode},
    middleware::Next,
    response::Response,
};
use tower::Layer;
use crate::db::Database;
use crate::services::auth_service::{verify_token, extract_token_from_header};

#[derive(Clone)]
pub struct AuthLayer {
    pub jwt_secret: String,
}

impl AuthLayer {
    pub fn new(jwt_secret: String) -> Self {
        Self { jwt_secret }
    }
}

impl<S> Layer<S> for AuthLayer {
    type Service = S;

    fn layer(&self, service: S) -> Self::Service {
        service
    }
}

pub async fn auth_middleware(
    State(_db): State<Database>,
    request: Request,
    next: Next,
) -> Result<Response, StatusCode> {
    // Skip auth for certain routes
    let path = request.uri().path();
    if path.starts_with("/api/auth") || path == "/health" {
        return Ok(next.run(request).await);
    }

    // Extract token from Authorization header
    let auth_header = request
        .headers()
        .get(header::AUTHORIZATION)
        .and_then(|h| h.to_str().ok())
        .ok_or(StatusCode::UNAUTHORIZED)?;

    let token = extract_token_from_header(auth_header)
        .ok_or(StatusCode::UNAUTHORIZED)?;

    let _claims = verify_token(token, "your_jwt_secret_here")
        .map_err(|_| StatusCode::UNAUTHORIZED)?;

    // Add user info to request extensions if needed
    // request.extensions_mut().insert(user_info);

    Ok(next.run(request).await)
}
