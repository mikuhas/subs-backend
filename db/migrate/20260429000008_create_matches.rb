class CreateMatches < ActiveRecord::Migration[7.2]
  def change
    create_table :matches do |t|
      # user1_id < user2_id に正規化して重複を防ぐ（アプリ層で保証）
      t.references :user1, null: false, foreign_key: { to_table: :users }
      t.references :user2, null: false, foreign_key: { to_table: :users }
      t.datetime   :matched_at, null: false, default: -> { 'CURRENT_TIMESTAMP' }

      t.timestamps
    end

    add_index :matches, [:user1_id, :user2_id], unique: true
  end
end
