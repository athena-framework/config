module Athena::Config
  # Just used for typing.
  #
  # See `ACF::Annotations`.
  abstract struct AnnotationConfigurations; end

  # Wraps the hash of custom annotations applied to a given type/property/method.
  #
  # Abstracts the typing of the storage hash so that implementations need not handle anything type related.
  struct Annotations(T) < AnnotationConfigurations
    # Parent type of a custom configuration annotation.
    #
    # See `ACF::Annotations::Configuration`.
    abstract struct ConfigurationBase; end

    # Represents a custom annotation applied to a given type/property/method.
    #
    # Includes the positional and named arguments of the annotation.
    record Configuration(P, N) < ConfigurationBase, args : P, named_args : N do
      # Returns the value at the provided *index* from `self`'s positional arguments.
      def [](index : Number)
        @args[index]
      end

      # Returns the value at the provided *key* from `self`'s named arguments.
      def [](key : Symbol)
        @named_args[key]
      end
    end

    # Instantiates an empty `self`.
    def self.new
      new({nil => [] of ACF::Annotations::ConfigurationBase})
    end

    def initialize(@annotation_hash : Hash(T, Array(ACF::Annotations::ConfigurationBase))); end

    # Returns the `ACF::Annotation::Configuration` instance for the provided annotation *type*, optionally at the provided *index*.
    #
    # NOTE: Returns the _last_ `ACF::Annotations::Annotation` by default
    # to be consistent with [TypeNode#annotation](https://crystal-lang.org/api/Crystal/Macros/TypeNode.html#annotation(type:TypeNode):Annotation%7CNilLiteral-instance-method).
    def [](type, index : Int32 = -1) : ACF::Annotations::ConfigurationBase
      @annotation_hash[type][index]
    end

    # Returns the `ACF::Annotation::Configuration` instance for the provided annotation *type*, optionally at the provided *index*.
    # Returns or `nil` if the *key* could not be found.
    #
    # NOTE: Returns the _last_ `ACF::Annotations::Annotation` by default
    # to be consistent with [TypeNode#annotation](https://crystal-lang.org/api/Crystal/Macros/TypeNode.html#annotation(type:TypeNode):Annotation%7CNilLiteral-instance-method).
    def []?(type, index : Int32 = -1) : ACF::Annotations::ConfigurationBase?
      @annotation_hash[type]?.try &.[index]
    end

    # Returns an array of `ACF::Annotation::Configuration` instances for the provided annotation *type*.
    def fetch_all(type) : Array(ACF::Annotations::ConfigurationBase)
      @annotation_hash[type]
    end

    # Returns `true` if there are annotations of the provided *type*, otherwise `false`.
    def has_key?(type) : Bool
      @annotation_hash.has_key? type
    end
  end
end
