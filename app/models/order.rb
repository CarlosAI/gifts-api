class Order < ApplicationRecord
	belongs_to :schools
	belongs_to :user
	has_many :order_details
	has_many :order_recipients
end
