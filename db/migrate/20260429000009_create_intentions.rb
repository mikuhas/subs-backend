class CreateIntentions < ActiveRecord::Migration[7.2]
  def change
    create_table :intentions do |t|
      t.references :from_user, null: false, foreign_key: { to_table: :users }
      t.references :to_user,   null: false, foreign_key: { to_table: :users }
      t.string     :icon,      null: false   # 例: '📞'
      t.string     :label,     null: false   # 例: '電話をしたい'

      t.timestamps
    end

    # 1ペアにつき意欲は1件（UPSERT で更新）
    add_index :intentions, [:from_user_id, :to_user_id], unique: true
  end
end
