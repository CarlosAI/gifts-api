class OrderRecipient < ApplicationRecord
	belongs_to :recipient
	belongs_to :order
end
