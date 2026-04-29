class BoardPost < ApplicationRecord
  belongs_to :target_user, class_name: 'User'
  belongs_to :author,      class_name: 'User', optional: true

  validates :post_type, inclusion: { in: %w[good warning] }
  validates :content,   presence: true
end
