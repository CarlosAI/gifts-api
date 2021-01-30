class User < ApplicationRecord
	has_many :orders
	has_many :schools
	has_many :recipients
end
