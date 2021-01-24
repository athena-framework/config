module Athena::Config::Annotations
  # Can be applied to a type included within `ACF::Base` to allow it to be resolvable via an `ACF::ConfigurationResolverInterface`.
  # The annotation should be provided a "path", either as the first positional argument, or via the `path` field, to the object from the `ACF::Base` instance.
  #
  # ```
  # @[ACFA::Resolvable(path: "some_config.nested_config")]
  # struct OtherConfig
  #   getter other_config_option : String = "OTHER_OPTION"
  # end
  #
  # @[ACFA::Resolvable("some_config")]
  # struct SomeConfig
  #   getter some_config_option : String = "OPTION"
  #   getter nested_config : OtherConfig = OtherConfig.new
  # end
  #
  # # Reopen ACF::Base to add our custom configuration type.
  # class Athena::Config::Base
  #   getter some_config : SomeConfig = SomeConfig.new
  # end
  #
  # ACF::ConfigurationResolver.new.resolve(SomeConfig).some_config_option   # => OPTION
  # ACF::ConfigurationResolver.new.resolve(OtherConfig).other_config_option # => OTHER_OPTION
  # ```
  annotation Resolvable; end
end
