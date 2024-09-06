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
        self.version.eq(&other.version) && self.as_str().eq(&other.as_str())
    }
}

impl Eq for CondaVersion {}

impl PartialOrd for CondaVersion {
    fn partial_cmp(&self, other: &Self) -> Option<std::cmp::Ordering> {
        Some(self.cmp(other))
    }
}

impl Ord for CondaVersion {
    fn cmp(&self, other: &Self) -> std::cmp::Ordering {
        // First order by version then by string representation
        self.version
            .cmp(&other.version)
            .then_with(|| self.as_str().cmp(&other.as_str()))
    }
}

impl CondaVersion {
    /// Constructs a new instance from a [`Version`] and a source representation.
    pub fn new(version: rattler_conda_types::Version, source: impl ToString) -> Self {
        Self {
            version,
            source: Some(source.to_string().into_boxed_str()),
        }
    }

    /// Returns the [`Version`]
    pub fn version(&self) -> &rattler_conda_types::Version {
        &self.version
    }

    /// Returns the string representation of this instance. Either this is a reference to the source
    /// string or an owned formatted version of the stored version.
    pub fn as_str(&self) -> std::borrow::Cow<'_, str> {
        match &self.source {
            Some(source) => std::borrow::Cow::Borrowed(source.as_ref()),
            None => std::borrow::Cow::Owned(format!("{}", &self.version)),
        }
    }

    /// Convert this instance back into a [`Version`].
    pub fn into_version(self) -> rattler_conda_types::Version {
        self.version
    }
}

impl PartialEq<rattler_conda_types::Version> for CondaVersion {
    fn eq(&self, other: &rattler_conda_types::Version) -> bool {
        self.version.eq(other)
    }
}

impl PartialOrd<rattler_conda_types::Version> for CondaVersion {
    fn partial_cmp(&self, other: &rattler_conda_types::Version) -> Option<std::cmp::Ordering> {
        self.version.partial_cmp(other)
    }
}

impl From<rattler_conda_types::Version> for CondaVersion {
    fn from(version: rattler_conda_types::Version) -> Self {
        CondaVersion {
            version,
            source: None,
        }
    }
}

// impl From<CondaVersion> for rattler_conda_types::Version {
//     fn from(version: CondaVersion) -> Self {
//         version.version
//     }
// }

impl AsRef<rattler_conda_types::Version> for CondaVersion {
    fn as_ref(&self) -> &rattler_conda_types::Version {
        &self.version
    }
}

impl std::ops::Deref for CondaVersion {
    type Target = rattler_conda_types::Version;

    fn deref(&self) -> &Self::Target {
        &self.version
    }
}

impl std::fmt::Display for CondaVersion {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        match &self.source {
            Some(source) => write!(f, "{}", source.as_ref()),
            None => write!(f, "{}", &self.version),
        }
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

#[cfg(test)]
pub mod pg_test {
    use pgrx::pg_extern;

    pub fn setup(_options: Vec<&str>) {
        // perform one-off initialization when the pg_test framework starts
    }

    pub fn postgresql_conf_options() -> Vec<&'static str> {
        // return any postgresql.conf settings that are required for your tests
        vec![]
    }
}

#[cfg(not(feature = "no-schema-generation"))]
#[cfg(any(test, feature = "pg_test"))]
#[pg_schema]
mod tests {
    use crate::CondaVersion;
    use pgrx::prelude::*;
    use std::error::Error;

    use pretty_assertions::assert_eq;

    #[pg_test]
    fn test_condaversion_input_func() -> Result<(), Box<dyn Error>> {
        let value = Spi::get_one::<CondaVersion>("SELECT '1.2.3'::condaversion")?;
        assert_eq!(value.unwrap().source, Some("1.2.3".into()));
        Ok(())
    }

    #[pg_test]
    fn test_condaversion_output_func() -> Result<(), Box<dyn Error>> {
        let value = Spi::get_one::<String>("SELECT '3.4.5'::condaversion::text")?;
        assert_eq!(value, Some("3.4.5".into()));
        Ok(())
    }

    #[pg_test]
    fn test_condaversion_output_func_original() -> Result<(), Box<dyn Error>> {
        // 1.01 would be converted to 1.1 by rattler's Version. Test that we output
        // the original value.
        let value = Spi::get_one::<String>("SELECT '1.01'::condaversion::text")?;
        assert_eq!(value, Some("1.01".into()));
        Ok(())
    }

    #[pg_test]
    fn test_order() -> Result<(), Box<dyn Error>> {
        Spi::run(
            "CREATE TABLE versions (
                version condaversion
            );
            INSERT INTO versions(version) VALUES('0.5a1');
            INSERT INTO versions(version) VALUES('0.5b3');
            INSERT INTO versions(version) VALUES('0.5C1');
            INSERT INTO versions(version) VALUES('0.5');
            INSERT INTO versions(version) VALUES('0.9.6');
            INSERT INTO versions(version) VALUES('0.960923');
            INSERT INTO versions(version) VALUES('1.0');
            INSERT INTO versions(version) VALUES('1.1dev1');
            INSERT INTO versions(version) VALUES('0.4');
            INSERT INTO versions(version) VALUES('0.4.0');
            INSERT INTO versions(version) VALUES('0.4.1.rc');
            INSERT INTO versions(version) VALUES('0.4.1.RC');
            INSERT INTO versions(version) VALUES('0.4.1');
            INSERT INTO versions(version) VALUES('1.1_');
            INSERT INTO versions(version) VALUES('1.1a1');
            INSERT INTO versions(version) VALUES('1.1.0dev1');
            INSERT INTO versions(version) VALUES('1.1.dev1');
            INSERT INTO versions(version) VALUES('1.1.a1');
            INSERT INTO versions(version) VALUES('1.1.0rc1');
            INSERT INTO versions(version) VALUES('1.1.0');
            INSERT INTO versions(version) VALUES('1.1');
            INSERT INTO versions(version) VALUES('1.1.0post1');
            INSERT INTO versions(version) VALUES('1.1.post1');
            INSERT INTO versions(version) VALUES('1.1post1');
            INSERT INTO versions(version) VALUES('1996.07.12');
            INSERT INTO versions(version) VALUES('1!0.4.1');
            INSERT INTO versions(version) VALUES('1!3.1.1.6');
            INSERT INTO versions(version) VALUES('2!0.4.1');",
        )
        .unwrap();
        // let value = Spi::get_one::<Vec<str>>("SELECT version::text FROM versions ORDER BY version")?;
        let res: Result<Vec<Option<CondaVersion>>, pgrx::spi::SpiError> = Spi::connect(|client| {
            let mut cursor =
                client.open_cursor("SELECT version FROM versions ORDER BY version;", None);
            let table = cursor.fetch(28)?;
            table
                .into_iter()
                .map(|row| row.get::<CondaVersion>(1))
                .collect::<Result<Vec<_>, _>>()
        });

        let mut items = vec![];
        for item in res? {
            items.push(item.unwrap().to_string());
        }

        assert_eq!(
            items,
            vec![
                "0.4",
                "0.4.0",
                "0.4.1.RC", // case-insensitive comparison
                "0.4.1.rc",
                "0.4.1",
                "0.5a1",
                "0.5b3",
                "0.5C1", // case-insensitive comparison
                "0.5",
                "0.9.6",
                "0.960923",
                "1.0",
                "1.1dev1", // special case 'dev'
                "1.1_",    // appended underscore is special case for openssl-like versions
                "1.1a1",
                "1.1.0dev1", // special case 'dev'
                "1.1.dev1",  // 0 is inserted before string
                "1.1.a1",
                "1.1.0rc1",
                "1.1",
                "1.1.0",
                "1.1.0post1", // special case 'post'
                "1.1.post1",  // 0 is inserted before string
                "1.1post1",   // special case 'post'
                "1996.07.12",
                "1!0.4.1", // epoch increased
                "1!3.1.1.6",
                "2!0.4.1", // epoch increased again
            ]
        );

        Ok(())
    }

    #[pg_test]
    fn test_hash() {
        Spi::run(
            "CREATE TABLE condaversionext (
                version condaversion,
                data TEXT
            );
            CREATE TABLE condaversion_duo (
                version condaversion,
                foo_version condaversion
            );
            INSERT INTO condaversionext DEFAULT VALUES;
            INSERT INTO condaversion_duo DEFAULT VALUES;
            SELECT *
            FROM condaversion_duo
            JOIN condaversionext ON condaversion_duo.version = condaversionext.version;",
        )
        .unwrap();
    }

    // #[pg_test]
    // fn test_commutator() {
    //     Spi::run(
    //         "CREATE TABLE hexintext (
    //             id hexint,
    //             data TEXT
    //         );
    //         CREATE TABLE just_hexint (
    //             id hexint
    //         );
    //         SELECT *
    //         FROM just_hexint
    //         JOIN hexintext ON just_hexint.id = hexintext.id;",
    //     )
    //     .unwrap();
    // }
}
