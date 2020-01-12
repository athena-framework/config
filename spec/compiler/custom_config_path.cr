require "../spec_helper"

describe Athena::Config do
  describe ".config" do
    describe "with a custom path" do
      it "should return an ACF::Base instance" do
        ACF.config.foo.should eq "BAR"
      end
    end
  end
end
