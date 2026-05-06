use axum::{response::Json, routing::{get, post}, Router};

pub fn insights_router() -> Router {
    Router::new()
        .route("/insights/dna", get(dna))
        .route("/insights/weekly", get(weekly))
        .route("/insights/timeline", get(timeline))
        .route("/insights/generate", post(generate_insight))
}

async fn dna() -> Json<&'static str> {
    Json("dna insight placeholder")
}

async fn weekly() -> Json<&'static str> {
    Json("weekly insight placeholder")
}

async fn timeline() -> Json<&'static str> {
    Json("timeline insight placeholder")
}

async fn generate_insight() -> Json<&'static str> {
    Json("generate insight placeholder")
}
