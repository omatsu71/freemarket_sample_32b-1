class Item < ApplicationRecord
  extend ActiveHash::Associations::ActiveRecordExtensions
  has_one :trading, dependent: :destroy
  has_one :purchase, dependent: :destroy
  belongs_to :user
  belongs_to :brand, optional: true
  belongs_to :category
  has_many :images, dependent: :destroy
  accepts_nested_attributes_for :images, allow_destroy: true
  has_many :favorites
  has_many :purchaseds
  belongs_to_active_hash :prefecture
end
