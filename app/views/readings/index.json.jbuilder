json.readings do
  @readings.each do |reading|
    json.set! reading.id do
      json.id reading.id
      json.color reading.color
      json.number reading.number
      json.segment_ids reading.lines.map(&:id)
    end
  end
end
