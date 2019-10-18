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

ActiveRecord::Schema.define(version: 2019_10_18_212530) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "characters", force: :cascade do |t|
    t.string "text", null: false
    t.string "form", null: false
    t.integer "position_id", null: false
    t.index ["position_id"], name: "index_characters_on_position_id"
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

end
