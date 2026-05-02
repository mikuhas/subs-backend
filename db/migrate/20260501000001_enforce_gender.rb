class EnforceGender < ActiveRecord::Migration[7.2]
  def up
    execute "UPDATE users SET gender = NULL WHERE gender NOT IN ('mens', 'womens')"
    change_column_null :users, :gender, false
    if ActiveRecord::Base.connection.adapter_name == 'Mysql2'
      execute "ALTER TABLE users ADD CONSTRAINT chk_users_gender CHECK (gender IN ('mens', 'womens'))"
    end
  end

  def down
    if ActiveRecord::Base.connection.adapter_name == 'Mysql2'
      execute "ALTER TABLE users DROP CONSTRAINT chk_users_gender"
    end
    change_column_null :users, :gender, true
  end
end
