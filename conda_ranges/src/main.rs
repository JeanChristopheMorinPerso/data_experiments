use std::str::FromStr;

use rattler_conda_types::version_spec::{EqualityOperator, RangeOperator, StrictRangeOperator};
use rattler_conda_types::{ParseStrictness, Version, VersionBumpType, VersionSpec};
use version_ranges::Ranges;

fn main() {
    let args: Vec<String> = std::env::args().collect();

    let spec = VersionSpec::from_str(&args[2], ParseStrictness::Lenient).unwrap();
    println!("spec: {}", spec);

    let mut ranges: Ranges<Version> = Ranges::empty();

    match spec {
        VersionSpec::Any => {
            ranges = ranges.union(&Ranges::full());
        }
        VersionSpec::None => {
            ranges = ranges.union(&Ranges::empty());
        }
        VersionSpec::Exact(op, ver) => match op {
            EqualityOperator::Equals => {
                ranges = ranges.union(&Ranges::singleton(ver));
            }
            EqualityOperator::NotEquals => {
                ranges = ranges.union(&Ranges::singleton(ver).complement());
            }
        },
        VersionSpec::Range(op, ver) => match op {
            RangeOperator::Greater => {
                ranges = ranges.union(&Ranges::strictly_higher_than(ver));
            }
            RangeOperator::GreaterEquals => {
                ranges = ranges.union(&Ranges::higher_than(ver));
            }
            RangeOperator::Less => {
                ranges = ranges.union(&Ranges::strictly_lower_than(ver));
            }
            RangeOperator::LessEquals => {
                ranges = ranges.union(&Ranges::lower_than(ver));
            }
        },
        VersionSpec::StrictRange(op, ver) => {
            let next_ver: Version;
            match ver.0.segment_count() {
                1 => {
                    next_ver = ver.0.bump(VersionBumpType::Major).expect("Failed to bump");
                }
                2 => {
                    next_ver = ver.0.bump(VersionBumpType::Minor).expect("Failed to bump");
                }
                3 => {
                    next_ver = ver.0.bump(VersionBumpType::Patch).expect("Failed to bump");
                }
                _ => {
                    next_ver = ver.0.bump(VersionBumpType::Last).expect("Failed to bump");
                }
            }
            println!(
                "VersionSpec::StrictRange: version {}, next: {}",
                ver.0, next_ver
            );

            match op {
                // ~=
                StrictRangeOperator::Compatible => {
                    let mut range: Ranges<Version> = Ranges::empty();
                    range = range.union(&Ranges::higher_than(ver.0));
                    range = range.intersection(&Ranges::strictly_lower_than(next_ver));
                    ranges = ranges.union(&range);
                }
                // !~=
                StrictRangeOperator::NotCompatible => {
                    let mut range: Ranges<Version> = Ranges::empty();
                    range = range.union(&Ranges::higher_than(ver.0));
                    range = range.intersection(&Ranges::strictly_lower_than(next_ver));
                    ranges = ranges.union(&range.complement());
                }
                // 1.*
                StrictRangeOperator::StartsWith => {
                    let mut range: Ranges<Version> = Ranges::empty();
                    range = range.union(&Ranges::higher_than(ver.0));
                    range = range.intersection(&Ranges::strictly_lower_than(next_ver));
                    ranges = ranges.union(&range);
                }
                // !=1.*
                StrictRangeOperator::NotStartsWith => {
                    let mut range: Ranges<Version> = Ranges::empty();
                    range = range.union(&Ranges::higher_than(ver.0));
                    range = range.intersection(&Ranges::strictly_lower_than(next_ver));
                    ranges = ranges.union(&range.complement());
                }
            }
        }
        VersionSpec::Group(op, vers) => println!("Group"),
    }

    println!("Computed ranges: {}", ranges);
    let contained = ranges.contains(&Version::from_str(&args[3]).unwrap());
    if contained {
        println!("{:?} is contained in {:?}", args[3], args[2]);
    } else {
        println!("{:?} is not contained in {:?}", args[3], args[2]);
    }

}
