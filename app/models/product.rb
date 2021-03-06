class Product < ApplicationRecord
  has_many :images, dependent: :destroy, index_errors: true
  accepts_nested_attributes_for :images, allow_destroy: true
  belongs_to :user, optional: true
  has_many :likes, dependent: :destroy
  has_many :like_users, through: :likes, source: :user
  has_many :comments
  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to_active_hash :prefecture
  belongs_to_active_hash :delivarydate
  belongs_to_active_hash :status
  belongs_to_active_hash :shippingcharges, optional: true
  belongs_to :category, optional: true
  validates :images,:name,:price,:description,:status_id,:delivery_date_id,:prefecture_id,:shopping_charge_id,:categories_id,:saler_id,presence: true
  validates :categories_id, numericality: { only_integer: true}


  def self.search(search)
    return Product.all unless search
    Product.where(['name LIKE ?', "%#{search}%"])
  end
  
  def like?(user)
    like_users.include?(user)
  end

end
