class CreateBoardPosts < ActiveRecord::Migration[7.2]
  def change
    create_table :board_posts do |t|
      # レビュー対象のユーザー
      t.references :target_user, null: false, foreign_key: { to_table: :users }
      # 投稿者（匿名投稿は NULL）
      t.references :author,      foreign_key: { to_table: :users }

      t.string  :post_type,      null: false  # 'good' | 'warning'
      t.text    :content,        null: false
      t.integer :helpful_count,  null: false, default: 0
      t.integer :agree_count,    null: false, default: 0
      t.boolean :admin_reviewed, null: false, default: false  # 運営確認済み

      t.timestamps
    end

    add_index :board_posts, [:target_user_id, :post_type]
  end
end
