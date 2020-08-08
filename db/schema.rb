# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_08_07_031257) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "character_segment_assignments", force: :cascade do |t|
    t.integer "character_id", null: false
    t.integer "segment_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["character_id"], name: "index_character_segment_assignments_on_character_id"
    t.index ["segment_id"], name: "index_character_segment_assignments_on_segment_id"
  end

  create_table "characters", force: :cascade do |t|
    t.string "text", null: false
    t.string "form", null: false
    t.integer "position_id", null: false
    t.boolean "rhyme", default: false
    t.index ["position_id"], name: "index_characters_on_position_id"
  end

  create_table "pinyin_forms", force: :cascade do |t|
    t.integer "character_id", null: false
    t.string "text_diacritic", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["character_id"], name: "index_pinyin_forms_on_character_id"
  end

  create_table "positions", force: :cascade do |t|
    t.integer "x_coordinate", null: false
    t.integer "y_coordinate", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "color"
    t.index ["color"], name: "index_positions_on_color"
    t.index ["x_coordinate", "y_coordinate"], name: "index_positions_on_x_coordinate_and_y_coordinate"
  end

  create_table "reading_segment_assignments", force: :cascade do |t|
    t.integer "reading_id", null: false
    t.integer "segment_id", null: false
    t.integer "line_number", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["reading_id"], name: "index_reading_segment_assignments_on_reading_id"
    t.index ["segment_id"], name: "index_reading_segment_assignments_on_segment_id"
  end

  create_table "readings", force: :cascade do |t|
    t.string "color", null: false
    t.integer "number", null: false
    t.integer "interpretation", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "block_number", null: false
    t.boolean "enabled", default: true, null: false
    t.index ["interpretation", "color", "block_number", "number"], name: "index_readings_on_interpretation_block_and_number"
  end

  create_table "segments", force: :cascade do |t|
    t.integer "head_position_id", null: false
    t.integer "tail_position_id", null: false
    t.integer "length", null: false
    t.string "color", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["head_position_id"], name: "index_segments_on_head_position_id"
    t.index ["tail_position_id"], name: "index_segments_on_tail_position_id"
  end

end
