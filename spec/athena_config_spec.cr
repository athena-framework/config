require "./spec_helper"

describe Athena::Config do
  describe ".config_path" do
    it "should use the default path if an ENV var is not defined" do
      ENV[ACF::CONFIG_PATH_NAME]?.should be_nil
      ACF.config_path.should eq ACF::DEFAULT_CONFIG_PATH
    end

    it "should use ENV var path if defined" do
      ENV[ACF::CONFIG_PATH_NAME] = "FOO"
      ACF.config_path.should eq "FOO"
    end
  end

  describe ".config" do
    describe "with the default path" do
      it "should return an ACF::Base instance" do
        ACF.config.foo.should be_nil
      end
    end
  end
end
