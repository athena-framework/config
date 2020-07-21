require "spec"
require "../src/athena-config"

struct Athena::Config::Base
  getter foo : String? = nil
  getter test : Athena::Config::Test = Athena::Config::Test.new
end

struct Athena::Config::Test
  include ACF::Configuration

  getter bar : Int32 = 12
end

struct Athena::Config::ConfigurationResolver
  # :inherit:
  def resolve(_type : Athena::Config::Test.class) : Athena::Config::Test
    base.test
  end
end

macro new_annotation_array(*configurations)
  [{{configurations.splat}}] of ACF::AnnotationConfigurations::ConfigurationBase
end
