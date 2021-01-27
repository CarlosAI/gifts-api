class Order < ApplicationRecord
	belongs_to :schools
	has_many :order_details
	has_many :order_recipients
end
