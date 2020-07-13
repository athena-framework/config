require "./spec_helper"

annotation One; end
annotation Two; end

describe ACF::Annotations do
  describe "#[]" do
    it "returns the last annotation by default" do
      ACF::Annotations.new({One => new_annotation_array({ {1}, nil }, { {2}, nil })})[One][0].should eq 2
    end

    it "allows returning a specific index" do
      ACF::Annotations.new({One => new_annotation_array({ {1}, nil }, { {2}, nil })})[One, 0][0].should eq 1
    end
  end

  describe "#[]?" do
    it "returns the last annotation by default" do
      annotations = ACF::Annotations.new({One => new_annotation_array({ {1}, nil }, { {2}, nil })})[One]?
      ann = annotations.should_not be_nil
      ann[0].should eq 2
    end

    it "allows returning a specific index" do
      annotations = ACF::Annotations.new({One => new_annotation_array({ {1}, nil }, { {2}, nil })})[One, 0]?
      ann = annotations.should_not be_nil
      ann[0].should eq 1
    end

    it "returns nil if no annotations of that type exist" do
      ACF::Annotations.new({One => new_annotation_array({ {1}, nil }, { {2}, nil })})[Two]?.should be_nil
    end
  end

  describe "#fetch_all" do
    it "returns an array of all annotations of that type" do
      anns = ACF::Annotations.new({One => new_annotation_array({ {1}, nil }, { {2}, nil })}).fetch_all(One)

      anns.size.should eq 2
      anns[0][0].should eq 1
      anns[1][0].should eq 2
    end
  end

  describe "#has_key?" do
    it "returns true if that annotation is present" do
      ACF::Annotations.new({One => new_annotation_array({ {1}, nil }, { {2}, nil })}).has_key?(One).should be_true
    end
  end
end
