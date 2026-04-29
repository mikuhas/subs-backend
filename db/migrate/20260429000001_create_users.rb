class CreateUsers < ActiveRecord::Migration[7.2]
  def change
    create_table :users do |t|
      # 認証
      t.string  :email,                  null: false
      t.string  :password_digest,        null: false

      # 基本情報
      t.string  :name,                   null: false
      t.integer :age,                    null: false
      t.text    :bio
      t.string  :image_url

      # 属性
      t.string  :gender                  # 'mens' | 'womens' | 'kids'
      t.integer :height
      t.string  :body_type

      # 沿線・エリア
      t.string  :line                    # 最寄り沿線（マッチング表示用）
      t.string  :preferred_line          # 好きな沿線
      t.string  :preferred_meeting_area  # 出会いたいエリア
      t.string  :frequent_station        # よく遊ぶ駅
      t.string  :first_date_station      # 最初のデート希望場所

      # マッチング設定
      t.boolean :random_match_enabled,   default: true, null: false

      # 位置情報（暫定: 将来は lat/lng から計算）
      t.decimal :distance_km,            precision: 5, scale: 1

      t.timestamps
    end

    add_index :users, :email, unique: true
  end
end
