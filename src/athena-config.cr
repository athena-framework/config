require "yaml"

require "./annotation_configurations"
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
  # * `ACF::Annotations` stores custom configuration annotations registered via `Athena::Config.register_configuration_annotation`.
  # Annotations must be read/supplied to `.new` by owning shard.
  #
  # See each specific type for more detailed information.
  module Config
    # :nodoc:
    CUSTOM_ANNOTATIONS = [] of Nil

    # Registers a configuration annotation with the provided *name*.
    # Defines a configuration record with the provided *args*, if any, that represents the possible arguments that the annotation accepts.
    # May also be used with a block to add custom methods to the configuration record.
    #
    # ### Example
    #
    # ```
    # # Defines an annotation without any arguments.
    # ACF.configuration_annotation Secure
    #
    # # Defines annotation with a required and optional argument.
    # # The default value will be used if that key isn't supplied in the annotation.
    # ACF.configuration_annotation SomeAnn, id : Int32, debug : Bool = true
    #
    # # A block can be used to define custom methods on the configuration object.
    # ACF.configuration_annotation CustomAnn, first_name : String, last_name : String do
    #   def name : String
    #     "#{@first_name} #{@last_name}"
    #   end
    # end
    # ```
    #
    # NOTE: The logic to actually do the resolution of the annotations must be handled in the owning shard.
    # `Athena::Config` only defines the common logic that each implementation can use.
    # See `ACF::AnnotationConfigurations` for more information.
    macro configuration_annotation(name, *args, &)
      annotation {{name.id}}; end

      # :nodoc:
      record {{name.id}}Configuration < ACF::AnnotationConfigurations::ConfigurationBase{% unless args.empty? %}, {{*args}}{% end %} do
        {{yield}}
      end

      {% CUSTOM_ANNOTATIONS << name %}
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
