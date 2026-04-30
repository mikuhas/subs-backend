class OptimizeDatabase < ActiveRecord::Migration[7.2]
  def up
    # ── users ──────────────────────────────────────────────────────────────
    change_column :users, :age,    :integer, limit: 1, unsigned: true, null: false
    change_column :users, :height, :integer, limit: 2
    add_index :users, [:random_match_enabled, :age],
              name: 'index_users_on_random_match_enabled_and_age',
              if_not_exists: true

    # ── likes ──────────────────────────────────────────────────────────────
    change_column :likes, :action, :string, limit: 10, null: false
    add_index :likes, [:from_user_id, :action],
              name: 'index_likes_on_from_user_id_and_action',
              if_not_exists: true
    remove_index :likes, name: 'index_likes_on_to_user_id', if_exists: true

    # ── matches ────────────────────────────────────────────────────────────
    execute "UPDATE matches SET matched_at = created_at WHERE matched_at IS NULL"
    change_column :matches, :matched_at, :datetime, null: false

    # ── messages ───────────────────────────────────────────────────────────
    remove_index :messages, name: 'index_messages_on_sender_id_and_receiver_id', if_exists: true
    remove_index :messages, name: 'index_messages_on_created_at',                if_exists: true
    # index_messages_on_sender_id は外部キー制約に必要なため削除不可
    add_index :messages, [:sender_id, :receiver_id, :created_at],
              name: 'index_messages_on_conversation',
              if_not_exists: true

    # ── board_posts ────────────────────────────────────────────────────────
    remove_index :board_posts, name: 'index_board_posts_on_target_user_id', if_exists: true

    # ── user_images ────────────────────────────────────────────────────────
    remove_index :user_images, name: 'index_user_images_on_user_id', if_exists: true
  end

  def down
    change_column :users, :age,    :integer, null: false
    change_column :users, :height, :integer
    remove_index :users, name: 'index_users_on_random_match_enabled_and_age'

    change_column :likes, :action, :string, null: false
    remove_index :likes, name: 'index_likes_on_from_user_id_and_action'
    add_index :likes, :to_user_id, name: 'index_likes_on_to_user_id'

    change_column :matches, :matched_at, :datetime

    remove_index :messages, name: 'index_messages_on_conversation', if_exists: true
    add_index :messages, [:sender_id, :receiver_id],  name: 'index_messages_on_sender_id_and_receiver_id', if_not_exists: true
    add_index :messages, :created_at,                 name: 'index_messages_on_created_at',                if_not_exists: true

    add_index :board_posts, :target_user_id, name: 'index_board_posts_on_target_user_id'
    add_index :user_images, :user_id,        name: 'index_user_images_on_user_id'
  end
end
