class CreateLikes < ActiveRecord::Migration[7.2]
  def change
    create_table :likes do |t|
      t.references :from_user, null: false, foreign_key: { to_table: :users }
      t.references :to_user,   null: false, foreign_key: { to_table: :users }
      t.string     :action,    null: false  # 'like' | 'skip'

      t.timestamps
    end

    # 同一ペアのアクションは1件のみ
    add_index :likes, [:from_user_id, :to_user_id], unique: true
    add_index :likes, [:to_user_id, :action]
  end
end
