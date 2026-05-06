use validator::Validate;

pub fn validate<T: Validate>(item: &T) -> anyhow::Result<()> {
    item.validate()?;
    Ok(())
}
