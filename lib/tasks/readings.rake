namespace :readings do
  task populate: :environment do
    ActiveRecord::Base.transaction do
      Reading.where(
        interpretation: :metail,
        color: :red,
      ).delete_all

      Reading.all.each do |reading|
        Reading.create_adjacent_red_reading!(reading)
      end
    end
  end
end
