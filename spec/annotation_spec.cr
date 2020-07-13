require "./spec_helper"

annotation One; end
annotation Two; end

describe ACF::Annotations::Annotation do
  describe "#[]" do
    it "accesses postional arguments with a number argument" do
      ACF::Annotations::Annotation.new({1, 2}, {foo: "Bar"})[1].should eq 2
    end

    it "accesses named arguments with a symbol argument" do
      ACF::Annotations::Annotation.new({1, 2}, {foo: "Bar"})[:foo].should eq "Bar"
    end
  end

  describe "#args" do
    it "returns a tuple of all postional arguments" do
      ACF::Annotations::Annotation.new({1, 2}, {foo: "Bar"}).args.should eq({1, 2})
    end
  end

  describe "#named_args" do
    it "returns a named tuple of all named arguments" do
      ACF::Annotations::Annotation.new({1, 2}, {foo: "Bar"}).named_args.should eq({foo: "Bar"})
    end
  end
end
