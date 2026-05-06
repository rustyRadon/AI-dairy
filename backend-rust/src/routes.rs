use crate::config::Config;
use crate::db::Database;
use crate::handlers::auth::auth_router;
use crate::handlers::conversation::conversation_router;
use crate::handlers::health::health_router;
use crate::handlers::insights::insights_router;
use crate::handlers::journal::journal_router;
use crate::handlers::memory::memory_router;
use crate::handlers::settings::settings_router;
use crate::handlers::streaks::streaks_router;
use crate::handlers::inbox::inbox_router;
use axum::Router;

pub fn create_router(_config: &Config, db: Database) -> Router {
    Router::new()
        .merge(health_router())
        .merge(auth_router(db.clone()))
        .merge(conversation_router(db.clone()))
        .merge(memory_router())
        .merge(journal_router())
        .merge(insights_router())
        .merge(settings_router())
        .merge(inbox_router())
        .merge(streaks_router())
}
