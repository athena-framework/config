require "./spec_helper"

describe Athena::Config do
  describe ".config_path" do
    it "allows fetching and setting the config path" do
      ENV[ACF::CONFIG_PATH_NAME]?.should be_nil
      ACF.config_path = "FOO"
      ENV[ACF::CONFIG_PATH_NAME]?.should eq "FOO"
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
