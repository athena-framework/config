require "./spec_helper"

private TEST_CASES = {
  {
    "resolvable_missing_path",
    "Configuration type 'OtherConfig' has an ACFA::Resolvable annotation but is missing the type's configuration path.  It was not provided as the first positional argument nor via the 'name' field.",
  },
}

describe Athena::Config do
  describe "compiler errors" do
    TEST_CASES.each do |(file_path, message)|
      it file_path do
        assert_error "compiler/#{file_path}.cr", message
      end
    end
  end
end
