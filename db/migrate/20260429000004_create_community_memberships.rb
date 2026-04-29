class CreateCommunityMemberships < ActiveRecord::Migration[7.2]
  def change
    create_table :community_memberships do |t|
      t.references :user,      null: false, foreign_key: true
      t.references :community, null: false, foreign_key: true
      t.datetime   :joined_at, null: false, default: -> { 'CURRENT_TIMESTAMP' }

      t.timestamps
    end

    add_index :community_memberships, [:user_id, :community_id], unique: true
  end
end
