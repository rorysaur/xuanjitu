json.readings @readings do |reading|
  json.id reading.id
  json.color reading.color
  json.block_number reading.block_number
  json.number reading.number
  json.segment_ids reading.segments.map(&:id)
  json.length reading.segments.size
end
