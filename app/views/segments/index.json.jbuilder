json.segments @segments do |segment|
  json.id segment.id
  json.head_x segment.head_x
  json.head_y segment.head_y
  json.tail_x segment.tail_x
  json.tail_y segment.tail_y
  json.length segment.length
  json.color segment.color
end
