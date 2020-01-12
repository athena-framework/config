require "./spec_helper"

describe Athena::Config::ConfigurationResolver do
  describe "#resolve" do
    it "should return an ACF::Base instance" do
      config = ACF::ConfigurationResolver.new.resolve
      config.should be_a ACF::Base
      config.foo.should be_nil
    end
  end

  describe "#resolve(_type)" do
    describe "that exists" do
      it "should resolve the given configuration object" do
        config = ACF::ConfigurationResolver.new.resolve ACF::Test
        config.should be_a ACF::Test
        config.bar.should eq 12
      end
    end

    describe "that does not exist" do
      it "should raise an exception" do
        expect_raises(NotImplementedError, "Not Implemented: Unable to resolve configuration for type 'Athena::Config::Base'") do
          ACF::ConfigurationResolver.new.resolve ACF::Base
        end
      end
    end
  end
end
