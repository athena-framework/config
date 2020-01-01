# Base config type that wraps the `Athena` configuration file.
#
# Components may add their own types to `self` to allow configuring that specific component.
struct Athena::Config::Base
  include YAML::Serializable
  include YAML::Serializable::Strict
end
