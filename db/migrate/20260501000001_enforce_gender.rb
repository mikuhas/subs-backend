class EnforceGender < ActiveRecord::Migration[7.2]
  def up
    # kids を NULL に変換してから NOT NULL + check 制約を追加
    execute "UPDATE users SET gender = NULL WHERE gender NOT IN ('mens', 'womens')"
    change_column_null :users, :gender, false
    execute "ALTER TABLE users ADD CONSTRAINT chk_users_gender CHECK (gender IN ('mens', 'womens'))"
  end

  def down
    execute "ALTER TABLE users DROP CONSTRAINT chk_users_gender"
    change_column_null :users, :gender, true
  end
end
