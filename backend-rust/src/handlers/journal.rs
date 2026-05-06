use crate::db::Database;
use crate::models::journal::{JournalEntry, CreateJournalRequest};
use crate::utils::jwt::Claims;
use axum::{
    extract::{Path, State},
    http::StatusCode,
    response::Json,
    routing::{get, post, put, delete},
    Router,
};
use mongodb::bson::{doc, oid::ObjectId};
use futures::stream::TryStreamExt;

pub fn journal_router(db: Database) -> Router {
    Router::new()
        .route("/journal/entries", post(create_entry).get(list_entries))
        .route("/journal/entries/:id", put(update_entry).delete(delete_entry))
        .with_state(db)
}

async fn create_entry(
    State(db): State<Database>,
    claims: Claims,
    Json(payload): Json<CreateJournalRequest>,
) -> Result<Json<JournalEntry>, StatusCode> {
    let collection = db.inner.collection::<JournalEntry>("journal_entries");
    let user_id = ObjectId::parse_str(&claims.sub).map_err(|_| StatusCode::BAD_REQUEST)?;

    let now = chrono::Utc::now();
    let entry = JournalEntry {
        id: None,
        user_id,
        title: payload.title,
        pinned: false, // Default to unpinned
        content: payload.content,
        mood: payload.mood,
        created_at: now,
        updated_at: now,
    };

    let result = collection.insert_one(&entry, None).await
        .map_err(|_| StatusCode::INTERNAL_SERVER_ERROR)?;
    
    let mut entry = entry;
    entry.id = Some(result.inserted_id.as_object_id().unwrap());

    Ok(Json(entry))
}

async fn list_entries(
    State(db): State<Database>,
    claims: Claims,
) -> Result<Json<Vec<JournalEntry>>, StatusCode> {
    let collection = db.inner.collection::<JournalEntry>("journal_entries");
    let user_id = ObjectId::parse_str(&claims.sub).map_err(|_| StatusCode::BAD_REQUEST)?;

    // Return entries for the specific user, sorted by pinned first, then date
    let find_options = mongodb::options::FindOptions::builder()
        .sort(doc! { "pinned": -1, "created_at": -1 })
        .build();

    let mut cursor = collection.find(doc! { "user_id": user_id }, find_options).await
        .map_err(|_| StatusCode::INTERNAL_SERVER_ERROR)?;

    let mut entries = Vec::new();
    while let Some(entry) = cursor.try_next().await.map_err(|_| StatusCode::INTERNAL_SERVER_ERROR)? {
        entries.push(entry);
    }

    Ok(Json(entries))
}

async fn update_entry(
    State(db): State<Database>,
    claims: Claims,
    Path(id): Path<String>,
    Json(payload): Json<CreateJournalRequest>,
) -> Result<StatusCode, StatusCode> {
    let collection = db.inner.collection::<JournalEntry>("journal_entries");
    let entry_oid = ObjectId::parse_str(&id).map_err(|_| StatusCode::BAD_REQUEST)?;
    let user_oid = ObjectId::parse_str(&claims.sub).map_err(|_| StatusCode::BAD_REQUEST)?;

    let update = doc! {
        "$set": {
            "title": payload.title,
            "content": payload.content,
            "mood": payload.mood,
            "updated_at": chrono::Utc::now()
        }
    };

    // Ensure we only update the entry if it belongs to the user
    let result = collection.update_one(doc! { "_id": entry_oid, "user_id": user_oid }, update, None).await
        .map_err(|_| StatusCode::INTERNAL_SERVER_ERROR)?;

    if result.matched_count == 0 {
        return Err(StatusCode::NOT_FOUND);
    }

    Ok(StatusCode::OK)
}

async fn delete_entry(
    State(db): State<Database>,
    claims: Claims,
    Path(id): Path<String>,
) -> Result<StatusCode, StatusCode> {
    let collection = db.inner.collection::<JournalEntry>("journal_entries");
    let entry_oid = ObjectId::parse_str(&id).map_err(|_| StatusCode::BAD_REQUEST)?;
    let user_oid = ObjectId::parse_str(&claims.sub).map_err(|_| StatusCode::BAD_REQUEST)?;

    let result = collection.delete_one(doc! { "_id": entry_oid, "user_id": user_oid }, None).await
        .map_err(|_| StatusCode::INTERNAL_SERVER_ERROR)?;

    if result.deleted_count == 0 {
        return Err(StatusCode::NOT_FOUND);
    }

    Ok(StatusCode::NO_CONTENT)
}