use crate::models::journal::JournalEntry;
use chrono::Utc;

pub async fn create_entry(_user_id: &str, _content: &str) -> anyhow::Result<JournalEntry> {
    Ok(JournalEntry {
        id: "placeholder".to_string(),
        user_id: _user_id.to_string(),
        content: _content.to_string(),
        pinned: false,
        created_at: Utc::now().to_rfc3339(),
        updated_at: Utc::now().to_rfc3339(),
    })
}
