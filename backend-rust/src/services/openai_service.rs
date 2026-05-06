use anyhow::Context;
use reqwest::Client;

pub struct OpenAiService {
    pub api_key: String,
    pub client: Client,
}

impl OpenAiService {
    pub fn new(api_key: String) -> Self {
        Self {
            api_key,
            client: Client::new(),
        }
    }

    pub async fn generate_text(&self, prompt: &str) -> anyhow::Result<String> {
        let request_body = serde_json::json!({
            "model": "gpt-4o-mini",
            "prompt": prompt,
            "max_tokens": 300,
        });

        let response = self
            .client
            .post("https://api.openai.com/v1/completions")
            .bearer_auth(&self.api_key)
            .json(&request_body)
            .send()
            .await
            .context("OpenAI request failed")?;

        let json: serde_json::Value = response.json().await?;
        let text = json["choices"][0]["text"].as_str().unwrap_or_default().to_string();
        Ok(text)
    }
}
