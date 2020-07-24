require "minitest/hooks"

describe "seeds" do
  before(:all) do
    Rails.application.load_seed
  end

  after(:all) do
    Position.delete_all
    Character.delete_all
    Segment.delete_all
    CharacterSegmentAssignment.delete_all
    Reading.delete_all
    ReadingSegmentAssignment.delete_all
  end

  describe "positions" do
    it "there are the expected number of them" do
      _(Position.count).must_equal 841
    end
  end

  describe "characters" do
    it "there is exactly one for every position" do
      Position.all.each do |position|
        characters_for_position = Character.where(position: position).count
        message = "fails at #{position.x_coordinate}, #{position.y_coordinate}"
        _(characters_for_position).must_equal 1, message
      end
    end
  end

  describe "segments" do
    it "every character has at least one segment" do
      Character.all.each do |character|
        next if (character.x_coordinate == 14) && (character.y_coordinate == 14)

        message = "fails for character #{character.text} at #{character.x_coordinate}, #{character.y_coordinate}"

        _(character.segments.size).must_be :>=, 1, message
      end
    end
  end

  describe "readings" do
  end
end
