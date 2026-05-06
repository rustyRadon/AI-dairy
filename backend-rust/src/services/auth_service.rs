use anyhow::Result;
use bcrypt::{hash, verify, DEFAULT_COST};
use crate::utils::jwt::{encode_jwt, decode_jwt, Claims};
use std::time::{SystemTime, UNIX_EPOCH};

pub fn hash_password(password: &str) -> Result<String> {
    let hashed = hash(password, DEFAULT_COST)?;
    Ok(hashed)
}

pub fn verify_password(password: &str, hash: &str) -> Result<bool> {
    let is_valid = verify(password, hash)?;
    Ok(is_valid)
}

pub fn generate_token(user_id: &str, jwt_secret: &str) -> Result<String> {
    let now = SystemTime::now()
        .duration_since(UNIX_EPOCH)
        .unwrap()
        .as_secs() as usize;
    
    let claims = Claims {
        sub: user_id.to_string(),
        exp: now + 24 * 60 * 60, // 24 hours
    };

    encode_jwt(jwt_secret, &claims)
}

pub fn verify_token(token: &str, jwt_secret: &str) -> Result<Claims> {
    decode_jwt(jwt_secret, token)
}

pub fn extract_token_from_header(auth_header: &str) -> Option<&str> {
    if auth_header.starts_with("Bearer ") {
        Some(&auth_header[7..])
    } else {
        None
    }
}
