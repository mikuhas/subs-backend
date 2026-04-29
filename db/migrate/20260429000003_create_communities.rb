class CreateCommunities < ActiveRecord::Migration[7.2]
  def change
    create_table :communities do |t|
      t.string  :name,         null: false
      t.string  :tag,          null: false   # カテゴリタグ（例: 'カフェ・グルメ'）
      t.text    :description
      t.string  :icon_class,   null: false   # Remixicon クラス名（例: 'ri-cup-line'）
      t.integer :member_count, null: false, default: 0

      t.timestamps
    end

    add_index :communities, :tag
  end
end
