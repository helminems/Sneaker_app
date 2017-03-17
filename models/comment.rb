class Comment < ActiveRecord::Base # dishes type table
  belongs_to :sneaker
  belongs_to :user
 end
