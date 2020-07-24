require "minitest/autorun"

describe "#following_segments" do
  subject do
    Segment.create!(
      color: color,
      length: length,
      head_position: head_position,
      tail_position: tail_position,
    )
  end

  let(:head_x) { 4 }
  let(:head_y) { 3 }
  let(:tail_x) { head_x + (length - 1) }
  let(:tail_y) { head_y }
  let(:length) { 3 }
  let(:color) { :green }
  let(:num_steps) { length - 1 }

  let(:head_position) do
    Position.create!(
      x_coordinate: head_x,
      y_coordinate: head_y,
    )
  end
  let(:tail_position) do
    Position.create!(
      x_coordinate: tail_x,
      y_coordinate: tail_y,
    )
  end

  let(:some_adjacent_segments) do
    left = { x: tail_x - 1, y: tail_y, direction: :left }
    upper_right = { x: tail_x + 1, y: tail_y - 1, direction: :right }
    down = { x: tail_x, y: tail_y + 1, direction: :down }

    [left, upper_right, down].map do |attrs|
      adjacent_head_position = Position.create!(
        x_coordinate: attrs[:x],
        y_coordinate: attrs[:y],
      )

      adjacent_tail_position_coordinates =
        case attrs[:direction]
        when :left
          { x: attrs[:x] - num_steps, y: attrs[:y] }
        when :right
          { x: attrs[:x] + num_steps, y: attrs[:y] }
        when :up
          { x: attrs[:x],  y: attrs[:y] - num_steps }
        when :down
          { x: attrs[:x],  y: attrs[:y] + num_steps }
        end

      adjacent_tail_position = Position.create!(
        x_coordinate: adjacent_tail_position_coordinates[:x],
        y_coordinate: adjacent_tail_position_coordinates[:y],
      )

      Segment.create!(
        head_position: adjacent_head_position,
        tail_position: adjacent_tail_position,
        color: color,
        length: length,
      )
    end
  end

  let(:non_adjacent_segment) do
    non_adjacent_head_position = some_adjacent_segments.first.tail_position
    non_adjacent_tail_position = Position.create!(
      x_coordinate: non_adjacent_head_position.x_coordinate,
      y_coordinate: non_adjacent_head_position.y_coordinate + num_steps,
    )

    Segment.create!(
      head_position: non_adjacent_head_position,
      tail_position: non_adjacent_tail_position,
      color: color,
      length: length,
    )
  end

  before do
    some_adjacent_segments
  end

  after do
    Position.delete_all
    Segment.delete_all
  end

  describe "when candidate segments are of the same color and length" do
    let(:overlapping_segment) { some_adjacent_segments.first }
    let(:expected) { some_adjacent_segments - [overlapping_segment] }

    it "returns the expected collection" do
      _(subject.following_segments).must_equal expected
    end

    it "excludes segments that are too far away" do
      _(subject.following_segments).wont_include non_adjacent_segment
    end

    it "excludes overlapping segments" do
      _(subject.following_segments).wont_include overlapping_segment
    end
  end

  describe "when candidate segments are of a different color" do
    before do
      some_adjacent_segments.each do |segment|
        segment.update!(color: :red)
      end
    end

    it "returns an empty array" do
      _(subject.following_segments).must_be_empty
    end
  end

  describe "when candidate segments are of a different length" do
    before do
      some_adjacent_segments.each do |segment|
        segment.update!(length: length + 1)
      end
    end

    it "returns an empty array" do
      _(subject.following_segments).must_be_empty
    end
  end
end
