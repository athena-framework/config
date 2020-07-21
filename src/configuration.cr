# Helper mixin that includes the modules and defines the methods required for a configuration.
#
# Includes `YAML::Serializable` for handling deserializing the configuration file into a `ACF::Base` and `YAML::Serializable::Strict` to prevent unused/undefined configurations within the file.
#
# See `ACF::Base` for more information on defining custom configuration types.
module Athena::Config::Configuration
  macro included
    include YAML::Serializable
    include YAML::Serializable::Strict

    def initialize; end
  end
end
