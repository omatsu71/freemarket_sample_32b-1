class Favorite < ApplicationRecord
  validates :item_id, uniqueness: { scope: [:user_id, :item_id]}

  belongs_to :user
  belongs_to :item
end
