# TODO: Maybe replace these with an `athena-framework/core` repo to share types?
annotation Athena::DI::Register; end

module Athena::DI::Service; end

@[Athena::DI::Register]
# Service that allows resolving a specific configuration object by type.
#
# Component configurations that should be resolvable must reopen `self`
# and add a `#resolve` method with a type restriction thats returns the desired configuration.
struct Athena::Config::ConfigurationResolver
  include Athena::DI::Service

  def resolve : ACF::Base
    base
  end

  private def base : ACF::Base
    ACF.config
  end
end
