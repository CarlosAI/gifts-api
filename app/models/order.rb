class Order < ApplicationRecord
	belongs_to :school
	belongs_to :user
	has_many :order_details
	has_many :order_recipients
end
