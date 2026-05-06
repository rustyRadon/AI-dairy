use crate::models::memory::MemoryItem;
use chrono::Utc;

pub async fn extract_memory(_text: &str) -> anyhow::Result<MemoryItem> {
    Ok(MemoryItem {
        id: "placeholder".to_string(),
        user_id: "user-placeholder".to_string(),
        text: _text.to_string(),
        tags: vec![],
        created_at: Utc::now().to_rfc3339(),
    })
}
