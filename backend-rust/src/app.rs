use crate::auth::AuthLayer;
use crate::config::Config;
use crate::db::Database;
use crate::routes::create_router;
use axum::Router;

pub fn create_app(config: &Config, db: Database) -> Router {
    create_router(config, db).layer(AuthLayer::new(config.jwt_secret.clone()))
}
