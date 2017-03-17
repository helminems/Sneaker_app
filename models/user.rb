class User < ActiveRecord::Base # sneakers table
  has_secure_password
  has_many :comments
  has_many :sneakers
end
