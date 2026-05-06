use jsonwebtoken::{decode, DecodingKey, EncodingKey, Header, Validation};
use serde::{Deserialize, Serialize};

#[derive(Debug, Serialize, Deserialize)]
pub struct Claims {
    pub sub: String,
    pub exp: usize,
}

pub fn encode_jwt(secret: &str, claims: &Claims) -> anyhow::Result<String> {
    Ok(jsonwebtoken::encode(&Header::default(), claims, &EncodingKey::from_secret(secret.as_ref()))?)
}

pub fn decode_jwt(secret: &str, token: &str) -> anyhow::Result<Claims> {
    Ok(decode::<Claims>(token, &DecodingKey::from_secret(secret.as_ref()), &Validation::default())?.claims)
}
