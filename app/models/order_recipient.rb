class OrderRecipient < ApplicationRecord
	belongs_to :recipients
	belongs_to :orders
end
