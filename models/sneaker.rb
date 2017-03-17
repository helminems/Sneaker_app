class Sneaker < ActiveRecord::Base
  # self.inheritance_column = :_type_disabled
  has_many :comments
  validates :name, presence: true
end
