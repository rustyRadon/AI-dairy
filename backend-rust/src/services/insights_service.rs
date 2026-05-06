use crate::models::insight::Insight;
use chrono::Utc;

pub async fn generate_insight(_user_id: &str, _kind: &str) -> anyhow::Result<Insight> {
    Ok(Insight {
        id: "placeholder".to_string(),
        user_id: _user_id.to_string(),
        kind: _kind.to_string(),
        title: "Insight placeholder".to_string(),
        content: "This is a generated insight placeholder.".to_string(),
        created_at: Utc::now().to_rfc3339(),
    })
}
