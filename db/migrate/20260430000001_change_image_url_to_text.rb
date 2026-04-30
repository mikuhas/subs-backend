class ChangeImageUrlToText < ActiveRecord::Migration[7.2]
  def change
    change_column :users,       :image_url, :text
    change_column :user_images, :image_url, :text
  end
end
