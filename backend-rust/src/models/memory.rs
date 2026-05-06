use mongodb::bson::oid::ObjectId;
use serde::{Deserialize, Serialize};

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct Memory {
    #[serde(rename = "_id", skip_serializing_if = "Option::is_none")]
    pub id: Option<ObjectId>,
    pub user_id: ObjectId,
    pub conversation_id: ObjectId,
    pub content: String,    // The actual fact: "User has a meeting tomorrow"
    pub importance: i32,    // 1-5 scale
    pub tags: Vec<String>,  // e.g., ["work", "anxiety", "goal"]
    pub created_at: chrono::DateTime<chrono::Utc>,
}

#[derive(Debug, Deserialize)]
pub struct MemoryQuery {
    pub tag: Option<String>,
}