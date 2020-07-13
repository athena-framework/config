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

macro new_annotation_array(*pairs)
  {% annotations = [] of Nil %}

  {% for tup in pairs %}
    {% pos_args = tup[0] == nil ? "Tuple.new".id : tup[0] %}
    {% named_args = tup[1] == nil ? "NamedTuple.new".id : tup[1] %}

    {% annotations << "ACF::Annotations::Annotation.new(#{pos_args}, #{named_args})".id %}
  {% end %}

  {{annotations}} of ACF::Annotations::AnnotationContainer
end
