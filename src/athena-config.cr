require "yaml"

# Convenience alias to make referencing `Athena::Config` types easier.
alias ACF = Athena::Config

# A web framework comprised of reusable, independent components.
#
# See [Athena Framework](https://github.com/athena-framework) on Github.
module Athena
  # The name of the environment variable used to determine Athena's current environment.
  ENV_NAME = "ATHENA_ENV"

  # Returns the current environment Athena is in based on `ENV_NAME`.  Defaults to `development` if not defined.
  def self.environment : String
    ENV[ENV_NAME]? || "development"
  end

  # Athena's Config component contains common types for configuring a component.
  #
  # Currently the two primary types are `ACF::Base`, and `ACF::ConfigurationResolver`. `ACF::Base` represents the structure of Athena's YAML configuration file.
  # `ACF::ConfigurationResolver` allows resolving the configuration for a given component within a service.  See each specific type for more detailed information.
  module Config
    VERSION = "0.1.0"

    # The name of the environment variable that stores the path to the configuration file.
    CONFIG_PATH_NAME = "ATHENA_CONFIG_PATH"

    # The default path to the configuration file.
    DEFAULT_CONFIG_PATH = "./athena.yml"

    # Returns the `ACF::Base` object instantiated from the configuration file located at `.config_path`.
    #
    # The contents of the configuration file are included into the binary at compile time so that the file itself
    # does not need to be present for the binary to run.  The configuration string is not processed until `.config` is called for the first time
    # so that in the future it will respect ENV vars for the environment the binary is in.
    #
    # TODO: Handle resolving ENV vars and DI parameters within the configuration file.
    class_getter config : ACF::Base { ACF.load }

    # Returns the current path that the configuration file is located at.
    #
    # Falls back on `DEFAULT_CONFIG_PATH` if a `ATHENA_CONFIG_PATH` ENV variable is not defined.
    def self.config_path : String
      ENV[CONFIG_PATH_NAME]? || DEFAULT_CONFIG_PATH
    end

    protected def self.load : ACF::Base
      # TODO: Handle ENV vars and params
      ACF::Base.from_yaml {{read_file(env(CONFIG_PATH_NAME) || DEFAULT_CONFIG_PATH)}}
    rescue ex : YAML::ParseException
      raise "Error parsing Athena configuration file(#{ACF.config_path}): '#{ex.message}'"
    end

    # Helper mixin that includes the modules and defines the methods required a configuration.
    #
    # Includes `YAML::Serializable` for handling deserializing the configuration file into a `ACF::Base` and `YAML::Serializable::Strict` to prevent unused/undefined configurations within the file.
    #
    # See `ACF::Base` for more information on defining custom configuration types.
    module Configuration
      macro included
      include YAML::Serializable
      include YAML::Serializable::Strict

      def initialize; end
    end
    end
  end
end

require "./base"
require "./configuration_resolver"
