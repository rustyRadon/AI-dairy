use axum::{
    async_trait,
    extract::FromRequestParts,
    http::{request::Parts, StatusCode},
};
use jsonwebtoken::{decode, encode, DecodingKey, EncodingKey, Header, Validation};
use serde::{Deserialize, Serialize};

#[derive(Debug, Serialize, Deserialize)]
pub struct Claims {
    pub sub: String, // This is the User ID
    pub exp: usize,
}

// Your existing logic integrated
pub fn encode_jwt(secret: &str, claims: &Claims) -> anyhow::Result<String> {
    Ok(encode(&Header::default(), claims, &EncodingKey::from_secret(secret.as_ref()))?)
}

pub fn decode_jwt(secret: &str, token: &str) -> anyhow::Result<Claims> {
    Ok(decode::<Claims>(token, &DecodingKey::from_secret(secret.as_ref()), &Validation::default())?.claims)
}

// Axum Extractor: This protects your routes
#[async_trait]
impl<S> FromRequestParts<S> for Claims
where
    S: Send + Sync,
{
    type Rejection = StatusCode;

    async fn from_request_parts(parts: &Parts, _state: &S) -> Result<Self, Self::Rejection> {
        // 1. Get the Authorization header
        let auth_header = parts
            .headers
            .get("Authorization")
            .and_then(|value| value.to_str().ok())
            .ok_or(StatusCode::UNAUTHORIZED)?;

        // 2. Check for "Bearer " prefix
        if !auth_header.starts_with("Bearer ") {
            return Err(StatusCode::UNAUTHORIZED);
        }

        let token = &auth_header[7..];
        
        // 3. Get secret from .env
        let secret = std::env::var("JWT_SECRET").map_err(|_| StatusCode::INTERNAL_SERVER_ERROR)?;

        // 4. Decode using your logic
        decode_jwt(&secret, token).map_err(|_| StatusCode::UNAUTHORIZED)
    }
}