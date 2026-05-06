use crate::db::Database;
use crate::models::memory::Memory; 
use crate::utils::jwt::Claims;
use axum::{
    extract::{State, Query},
    http::StatusCode,
    response::Json,
    routing::get,
    Router,
};
use mongodb::bson::{doc, oid::ObjectId};
use futures::stream::TryStreamExt;
use serde::Deserialize;

#[derive(Deserialize)]
pub struct MemoryQuery {
    pub tag: Option<String>,
}

pub fn memory_router(db: Database) -> Router {
    Router::new()
        .route("/memory/recall", get(recall_memories))
        .route("/memory/timeline", get(get_memory_timeline))
        .with_state(db)
}

async fn recall_memories(
    State(db): State<Database>,
    claims: Claims,
    Query(params): Query<MemoryQuery>,
) -> Result<Json<Vec<Memory>>, StatusCode> {
    let collection = db.inner.collection::<Memory>("memories");
    let user_id = ObjectId::parse_str(&claims.sub).map_err(|_| StatusCode::BAD_REQUEST)?;

    let mut filter = doc! { "user_id": user_id };
    if let Some(tag) = params.tag {
        filter.insert("tags", tag);
    }

    let mut cursor = collection.find(filter, None).await
        .map_err(|_| StatusCode::INTERNAL_SERVER_ERROR)?;

    let mut memories = Vec::new();
    while let Some(mem) = cursor.try_next().await.map_err(|_| StatusCode::INTERNAL_SERVER_ERROR)? {
        memories.push(mem);
    }

    Ok(Json(memories))
}

async fn get_memory_timeline(
    State(db): State<Database>,
    claims: Claims,
) -> Result<Json<Vec<Memory>>, StatusCode> {
    let collection = db.inner.collection::<Memory>("memories");
    let user_id = ObjectId::parse_str(&claims.sub).map_err(|_| StatusCode::BAD_REQUEST)?;

    // Sorting by date for the timeline
    let find_options = mongodb::options::FindOptions::builder()
        .sort(doc! { "created_at": -1 })
        .build();

    let mut cursor = collection.find(doc! { "user_id": user_id }, find_options).await
        .map_err(|_| StatusCode::INTERNAL_SERVER_ERROR)?;

    let mut memories = Vec::new();
    while let Some(mem) = cursor.try_next().await.map_err(|_| StatusCode::INTERNAL_SERVER_ERROR)? {
        memories.push(mem);
    }

    Ok(Json(memories))
}