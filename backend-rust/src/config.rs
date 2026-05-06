use std::env;

#[derive(Debug, Clone)]
pub struct Config {
    pub port: u16,
    pub mongo_uri: String,
    pub jwt_secret: String,
    pub openai_api_key: String,
    pub allowed_origins: Vec<String>,
}

impl Config {
    pub fn from_env() -> anyhow::Result<Self> {
        dotenvy::dotenv().ok();
        let port = env::var("PORT")?.parse()?;
        let mongo_uri = env::var("MONGO_URI")?;
        let jwt_secret = env::var("JWT_SECRET")?;
        let openai_api_key = env::var("OPENAI_API_KEY")?;
        let allowed_origins = env::var("ALLOWED_ORIGINS")?
            .split(',')
            .map(str::trim)
            .filter(|v| !v.is_empty())
            .map(String::from)
            .collect();

        Ok(Self {
            port,
            mongo_uri,
            jwt_secret,
            openai_api_key,
            allowed_origins,
        })
    }
}
