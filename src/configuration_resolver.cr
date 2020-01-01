# TODO: Maybe replace these with an `athena-framework/core` repo to share types?
annotation Athena::DI::Register; end

module Athena::DI::Service; end

# Service that allows resolving a specific configuration object by type.
#
# Component configurations that should be resolvable must reopen `self`
# and add a `#resolve` method with a type restriction thats returns the desired configuration.
module Athena::Config::ConfigurationResolverInterface
  # Returns the `ACF::Base` configuration object.
  abstract def resolve : ACF::Base

  # Resolves the configuration object for the given *_type*.
  abstract def resolve(_type : _) : _
end

@[Athena::DI::Register]
struct Athena::Config::ConfigurationResolver
  include Athena::DI::Service
  include Athena::Config::ConfigurationResolverInterface

  # :inherit:
  def resolve : ACF::Base
    base
  end

  private def base : ACF::Base
    ACF.config
  end
end
