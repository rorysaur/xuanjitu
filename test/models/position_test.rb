require "minitest/autorun"

describe "::sort" do
  describe "with the same y-coordinate" do
    let(:y) { 0 }
    let(:pos_a) { Position.new(x_coordinate: 0, y_coordinate: y) }
    let(:pos_b) { Position.new(x_coordinate: 2, y_coordinate: y) }
    let(:expected) { [pos_a, pos_b] }

    it "returns the expected array when arguments are already sorted" do
      result = Position.sort(pos_a, pos_b)
      _(result).must_equal expected
    end

    it "returns the expected array when arguments are in reverse order" do
      result = Position.sort(pos_b, pos_a)
      _(result).must_equal expected
    end
  end

  describe "with the same x-coordinate" do
    let(:x) { 0 }
    let(:pos_a) { Position.new(x_coordinate: x, y_coordinate: 0) }
    let(:pos_b) { Position.new(x_coordinate: x, y_coordinate: 2) }
    let(:expected) { [pos_a, pos_b] }

    it "returns the expected array when arguments are already sorted" do
      result = Position.sort(pos_a, pos_b)
      _(result).must_equal expected
    end

    it "returns the expected array when arguments are in reverse order" do
      result = Position.sort(pos_b, pos_a)
      _(result).must_equal expected
    end
  end

  describe "with different x- and y-coordinates" do
    let(:pos_a) { Position.new(x_coordinate: 0, y_coordinate: 0) }
    let(:pos_b) { Position.new(x_coordinate: 2, y_coordinate: 2) }

    it "raises an error" do
      assert_raises RuntimeError do
        Position.sort(pos_a, pos_b)
      end
    end
  end
end

describe "#between?" do
  describe "horizontally" do
    subject { Position.new(x_coordinate: 3, y_coordinate: y) }

    let(:y) { 0 }
    let(:pos_a) { Position.new(x_coordinate: 0, y_coordinate: y) }
    let(:pos_b) { Position.new(x_coordinate: 5, y_coordinate: y) }

    describe "forward direction" do
      let(:result) { subject.between?(pos_a, pos_b) }

      it "returns true" do
        _(result).must_equal true
      end
    end

    describe "reverse direction" do
      let(:result) { subject.between?(pos_b, pos_a) }

      it "returns true" do
        _(result).must_equal true
      end
    end
  end

  describe "vertically" do
    subject { Position.new(x_coordinate: x, y_coordinate: 3) }

    let(:x) { 0 }
    let(:pos_a) { Position.new(x_coordinate: x, y_coordinate: 0) }
    let(:pos_b) { Position.new(x_coordinate: x, y_coordinate: 5) }

    describe "forward direction" do
      let(:result) { subject.between?(pos_a, pos_b) }

      it "returns true" do
        _(result).must_equal true
      end
    end

    describe "reverse direction" do
      let(:result) { subject.between?(pos_b, pos_a) }

      it "returns true" do
        _(result).must_equal true
      end
    end
  end

  describe "diagonally" do
    subject { Position.new(x_coordinate: 3, y_coordinate: 3) }

    let(:pos_a) { Position.new(x_coordinate: 0, y_coordinate: 0) }
    let(:pos_b) { Position.new(x_coordinate: 5, y_coordinate: 5) }

    describe "forward direction" do
      it "raises an error" do
        assert_raises RuntimeError do
          subject.between?(pos_a, pos_b)
        end
      end
    end

    describe "reverse direction" do
      it "raises an error" do
        assert_raises RuntimeError do
          subject.between?(pos_b, pos_a)
        end
      end
    end
  end
end

describe "#adjacent_positions" do
  subject { Position.find_by!(x_coordinate: center_x, y_coordinate: center_y) }

  let(:min_coordinate) { 0 }
  let(:max_coordinate) { 9 }
  let(:results) { subject.adjacent_positions }
  let(:non_adjacent_position1) do
    Position.find_by(x_coordinate: center_x - 2, y_coordinate: center_y + 2)
  end
  let(:non_adjacent_position2) do
    Position.find_by(x_coordinate: center_x + 2, y_coordinate: center_y - 2)
  end

  before do
    (min_coordinate..max_coordinate).each do |y|
      (min_coordinate..max_coordinate).each do |x|
        Position.create!(
          x_coordinate: x,
          y_coordinate: y,
        )
      end
    end
  end

  after do
    Position.delete_all
  end

  describe "when center is in the middle" do
    let(:center_x) { 3 }
    let(:center_y) { 4 }

    it "returns a collection of the expected size" do
      _(results.size).must_equal 9
    end

    it "doesn't include non-adjacent positions" do
      _(results).wont_include non_adjacent_position1
      _(results).wont_include non_adjacent_position2
    end

    it "includes itself" do
      _(results).must_include subject
    end
  end

  describe "when center is in the upper left corner" do
    let(:center_x) { min_coordinate }
    let(:center_y) { min_coordinate }

    it "returns a collection of the expected size" do
      _(results.size).must_equal 4
    end

    it "doesn't include non-adjacent positions" do
      _(results).wont_include non_adjacent_position1
      _(results).wont_include non_adjacent_position2
    end

    it "includes itself" do
      _(results).must_include subject
    end
  end

  describe "when center is in the lower right corner" do
    let(:center_x) { max_coordinate }
    let(:center_y) { max_coordinate }

    it "returns a collection of the expected size" do
      _(results.size).must_equal 4
    end

    it "doesn't include non-adjacent positions" do
      _(results).wont_include non_adjacent_position1
      _(results).wont_include non_adjacent_position2
    end

    it "includes itself" do
      _(results).must_include subject
    end
  end
end
