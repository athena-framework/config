# A type that allows resolving a specific configuration object by type.
# The main usecase for this type is to abstract _how_ a configuration object is provided; making testing/future refactors easier.
# See `ACFA::Resolvable` for details.
module Athena::Config::ConfigurationResolverInterface
  # Returns the `ACF::Base` configuration object.
  abstract def resolve : ACF::Base

  # Resolves the configuration object for the given *_type*.
  #
  # Raises a `NotImplementedError` if no `#resolve` method exists for the given *_type*.
  abstract def resolve(_type : _)
end

# See `Athena::Config::ConfigurationResolverInterface`.
struct Athena::Config::ConfigurationResolver
  include Athena::Config::ConfigurationResolverInterface

  macro finished
    {% verbatim do %}
      {% begin %}
        {% for type in Object.all_subclasses.select &.annotation(ACFA::Resolvable) %}
          {% ann = type.annotation ACFA::Resolvable %}
          {% path = ann[0] || ann["path"] || type.raise "Configuration type '#{type}' has an ACFA::Resolvable annotation but is missing the type's configuration path.  It was not provided as the first positional argument nor via the 'name' field." %}

          # :inherit:
          def resolve(_type : {{type}}.class)
            base.{{path.id}}
          end
        {% end %}
      {% end %}
    {% end %}
  end

  def resolve(_type : _)
    raise NotImplementedError.new "Unable to resolve configuration for type '#{_type}'."
  end

  # :inherit:
  def resolve : ACF::Base
    base
  end

  private def base : ACF::Base
    ACF.config
  end
end
