json.readings @readings do |reading|
  json.id reading.id
  json.color reading.color
  json.number reading.number
  json.segment_ids reading.lines.map(&:id)
  json.length reading.lines.size
end
