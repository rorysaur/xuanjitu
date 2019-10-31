json.characters @characters do |char|
  json.text char.text
  json.form char.form
  json.x_coordinate char.x_coordinate
  json.y_coordinate char.y_coordinate
  json.color char.color
  json.rhyme char.rhyme?
  json.segment_ids char.segments.map(&:id)
end
