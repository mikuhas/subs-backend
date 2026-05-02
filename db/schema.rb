# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.2].define(version: 2026_05_01_000001) do
  create_table "board_posts", force: :cascade do |t|
    t.integer "target_user_id", null: false
    t.integer "author_id"
    t.string "post_type", null: false
    t.text "content", null: false
    t.integer "helpful_count", default: 0, null: false
    t.integer "agree_count", default: 0, null: false
    t.boolean "admin_reviewed", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_id"], name: "index_board_posts_on_author_id"
    t.index ["target_user_id", "post_type"], name: "index_board_posts_on_target_user_id_and_post_type"
  end

  create_table "communities", force: :cascade do |t|
    t.string "name", null: false
    t.string "tag", null: false
    t.text "description"
    t.string "icon_class", null: false
    t.integer "member_count", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tag"], name: "index_communities_on_tag"
  end

  create_table "community_memberships", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "community_id", null: false
    t.datetime "joined_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["community_id"], name: "index_community_memberships_on_community_id"
    t.index ["user_id", "community_id"], name: "index_community_memberships_on_user_id_and_community_id", unique: true
    t.index ["user_id"], name: "index_community_memberships_on_user_id"
  end

  create_table "intentions", force: :cascade do |t|
    t.integer "from_user_id", null: false
    t.integer "to_user_id", null: false
    t.string "icon", null: false
    t.string "label", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["from_user_id", "to_user_id"], name: "index_intentions_on_from_user_id_and_to_user_id", unique: true
    t.index ["from_user_id"], name: "index_intentions_on_from_user_id"
    t.index ["to_user_id"], name: "index_intentions_on_to_user_id"
  end

  create_table "likes", force: :cascade do |t|
    t.integer "from_user_id", null: false
    t.integer "to_user_id", null: false
    t.string "action", limit: 10, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["from_user_id", "action"], name: "index_likes_on_from_user_id_and_action"
    t.index ["from_user_id", "to_user_id"], name: "index_likes_on_from_user_id_and_to_user_id", unique: true
    t.index ["from_user_id"], name: "index_likes_on_from_user_id"
    t.index ["to_user_id", "action"], name: "index_likes_on_to_user_id_and_action"
  end

  create_table "matches", force: :cascade do |t|
    t.integer "user1_id", null: false
    t.integer "user2_id", null: false
    t.datetime "matched_at", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user1_id", "user2_id"], name: "index_matches_on_user1_id_and_user2_id", unique: true
    t.index ["user1_id"], name: "index_matches_on_user1_id"
    t.index ["user2_id"], name: "index_matches_on_user2_id"
  end

  create_table "messages", force: :cascade do |t|
    t.integer "sender_id", null: false
    t.integer "receiver_id", null: false
    t.text "body", null: false
    t.datetime "read_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["receiver_id"], name: "index_messages_on_receiver_id"
    t.index ["sender_id", "receiver_id", "created_at"], name: "index_messages_on_conversation"
    t.index ["sender_id"], name: "index_messages_on_sender_id"
  end

  create_table "user_images", force: :cascade do |t|
    t.integer "user_id", null: false
    t.text "image_url"
    t.integer "position", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "position"], name: "index_user_images_on_user_id_and_position"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.string "password_digest", null: false
    t.string "name", null: false
    t.integer "age", null: false
    t.text "bio"
    t.text "image_url"
    t.string "gender", null: false
    t.integer "height"
    t.string "body_type"
    t.string "line"
    t.string "preferred_line"
    t.string "preferred_meeting_area"
    t.string "frequent_station"
    t.string "first_date_station"
    t.boolean "random_match_enabled", default: true, null: false
    t.decimal "distance_km", precision: 5, scale: 1
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["random_match_enabled", "age"], name: "index_users_on_random_match_enabled_and_age"
  end

  add_foreign_key "board_posts", "users", column: "author_id"
  add_foreign_key "board_posts", "users", column: "target_user_id"
  add_foreign_key "community_memberships", "communities"
  add_foreign_key "community_memberships", "users"
  add_foreign_key "intentions", "users", column: "from_user_id"
  add_foreign_key "intentions", "users", column: "to_user_id"
  add_foreign_key "likes", "users", column: "from_user_id"
  add_foreign_key "likes", "users", column: "to_user_id"
  add_foreign_key "matches", "users", column: "user1_id"
  add_foreign_key "matches", "users", column: "user2_id"
  add_foreign_key "messages", "users", column: "receiver_id"
  add_foreign_key "messages", "users", column: "sender_id"
  add_foreign_key "user_images", "users"
end
