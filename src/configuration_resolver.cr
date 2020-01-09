# A type that allows resolving a specific configuration object by type.  Can be reopened to be made into a service to allow resolving configurations within other services.
#
# Component configurations that should be resolvable must reopen `self`
# and add a `#resolve` method with a type restriction thats returns the desired configuration.
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
# # Reopen ACF::Base to add our custom configuration type.
# struct Athena::Config::Base
#   getter some_config : SomeConfig
# end
#
# # Reopen ConfigurationResolver to add a method that allows resolving the `SomeConfig` object.
# #
# # Attempting to resolve a configuration type that has not been added will result in a `NotImplementedError`.
# struct Athena::Config::ConfigurationResolver
#   # :inherit:
#   def resolve(_type : SomeConfig.class) : SomeConfig
#     # A private `#base` helper method is defined which returns the `ACF::Base` instance.
#     base.some_config
#   end
# end
#
# # Assuming the YAML configuration file looks like:
# # ---
# # some_config:
# #  api_key: API_KEY
# ACF::ConfigurationResolver.new.resolve(SomeConfig).api_key # => API_KEY
# ```
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

  def resolve(_type : _)
    raise NotImplementedError.new "Unable to resolve configuration for type '#{_type}'"
  end

  # :inherit:
  def resolve : ACF::Base
    base
  end

  private def base : ACF::Base
    ACF.config
  end
end
