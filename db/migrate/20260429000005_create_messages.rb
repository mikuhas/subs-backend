class CreateMessages < ActiveRecord::Migration[7.2]
  def change
    create_table :messages do |t|
      t.references :sender,   null: false, foreign_key: { to_table: :users }
      t.references :receiver, null: false, foreign_key: { to_table: :users }
      t.text       :body,     null: false
      t.datetime   :read_at                # NULL = 未読

      t.timestamps
    end

    add_index :messages, [:sender_id, :receiver_id]
    add_index :messages, :created_at
  end
end
