use pgrx::prelude::*;
use serde::{Deserialize, Serialize};
use std::str::FromStr;

::pgrx::pg_module_magic!();

#[derive(PostgresType, Serialize, Deserialize, Debug, PostgresEq, PostgresOrd, PostgresHash)]
#[inoutfuncs]
pub struct CondaVersion {
    version: rattler_conda_types::Version,
    source: Option<Box<str>>,
}

impl std::hash::Hash for CondaVersion {
    fn hash<H: std::hash::Hasher>(&self, state: &mut H) {
        self.version.hash(state);
        self.source.hash(state);
    }
}

impl PartialEq for CondaVersion {
    fn eq(&self, other: &Self) -> bool {
        return self.version.eq(&other.version);
    }
}

impl Eq for CondaVersion {}

impl PartialOrd for CondaVersion {
    fn partial_cmp(&self, other: &Self) -> Option<std::cmp::Ordering> {
        return Some(self.cmp(other));
    }
}

impl Ord for CondaVersion {
    fn cmp(&self, other: &Self) -> std::cmp::Ordering {
        // First order by version then by string representation
        return self.version.cmp(&other.version);
    }
}

impl InOutFuncs for CondaVersion {
    fn input(input: &core::ffi::CStr) -> Self {
        let s = input.to_str().unwrap();
        let version = rattler_conda_types::Version::from_str(s).unwrap();
        return Self {
            version,
            source: Some(s.to_owned().into_boxed_str()),
        };
    }

    fn output(&self, buffer: &mut pgrx::StringInfo) {
        buffer.push_str(self.source.as_deref().unwrap());
    }
}
