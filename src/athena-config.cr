# Convenience alias to make referencing `Athena::Config` types easier.
alias ACF = Athena::Config

# Convenience alias to make referencing `ACF::Annotations` types easier.
alias ACFA = ACF::Annotations

require "./annotation_configurations"
require "./annotations"
require "./base"
require "./configuration_resolver"
require "./parameters"

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
  # * `ACF::Base` represents the configuration defining how various components/features should behave.
  # * `ACF::Parameters` represent reuseable configuration values.
  # * `ACF::ConfigurationResolver` allows resolving the configuration for a given component within a service.
  # * `ACF::AnnotationConfigurations` stores annotation configurations registered via `Athena::Config.configuration_annotation`.
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

    # Returns the `ACF::Base` object created via `ACF.load_configuration`.
    class_getter config : ACF::Base { ACF.load_configuration self.parameters }

    # Returns the `ACF::Parameters` object created via `ACF.load_parameters`.
    class_getter parameters : ACF::Parameters { ACF.load_parameters }

    # By default return an empty configuration type.
    protected def self.load_configuration(parameters : ACF::Parameters) : ACF::Base
      ACF::Base.new
    end

    # By default return an empty parameters type.
    protected def self.load_parameters : ACF::Parameters
      ACF::Parameters.new
    end
  end
end
