require "./athena-config"

# Base config type that wraps the `Athena` configuration file.
#
# Components may add their own `ACF::Configuration` types to `self` to allow configuring that specific component.
#
# ```
# # Define a custom configuration type.
# # Additional configuration types may be nested.
# struct SomeConfig
#   include ACF::Configuration
#
#   # Defines a required configuration property.
#   # Optional properties can be made nilable or given a default value.
#   getter api_key : String
# end
#
# # Reopen the base type to add our custom configuration type.
# struct Athena::Config::Base
#   getter some_config : SomeConfig
# end
# ```
#
# `ACF::Base`'s YAML representation now looks like:
# ```yaml
# ---
# some_config:
#   api_key: API_KEY
# ```
struct Athena::Config::Base
  include ACF::Configuration
end
