class Recipient < ApplicationRecord
	belongs_to :schools
	has_many :order_recipients
end
