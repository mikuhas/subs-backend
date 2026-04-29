class CreateUserImages < ActiveRecord::Migration[7.2]
  def change
    create_table :user_images do |t|
      t.references :user,      null: false, foreign_key: true
      t.string     :image_url, null: false
      t.integer    :position,  null: false, default: 0  # 表示順（0始まり）

      t.timestamps
    end

    add_index :user_images, [:user_id, :position]
  end
end
