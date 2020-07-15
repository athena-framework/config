require "yaml"

require "./annotations"
require "./base"
require "./configuration_resolver"

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
  # The main types include:
  #
  # * `ACF::Base` represents the structure of Athena's YAML configuration file.
  # * `ACF::ConfigurationResolver` allows resolving the configuration for a given component within a service.
  # * `ACF::Annotations` stores custom configuration annotations registered via `ACF.register_configuration_annotation`.
  # Annotations must be read/supplied to `.new` by owning shard.
  #
  # See each specific type for more detailed information.
  module Config
    # :nodoc:
    CUSTOM_ANNOTATIONS = [] of Nil

    # Registers a user defined annotation type that should be used to resolve custom annotation based configurations.
    #
    # NOTE: The logic to actually do the resolution must be handled in the owning shard.
    # `Athena::Config` only defines the common logic that each implementation can use.
    #
    # OPTIMIZE: Make this automated once [this issue](https://github.com/crystal-lang/crystal/issues/9322) is resolved.
    #
    # ### Example
    #
    # ```
    # annotation Security; end
    #
    # # Implementations would now pickup the `Security` annotation
    # # applied to supported types, methods, and instance variables.
    # ACF.register_configuration_annotation Security
    # ```
    macro register_configuration_annotation(annotation_type)
      {% CUSTOM_ANNOTATIONS << annotation_type %}
    end

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
      # If no file exists, create an empty config using default values
      ACF::Base.from_yaml {{read_file?(env(CONFIG_PATH_NAME) || DEFAULT_CONFIG_PATH) || ""}}
    rescue ex : YAML::ParseException
      raise "Error parsing Athena configuration file(#{ACF.config_path}): '#{ex.message}'"
    end
  end
end
