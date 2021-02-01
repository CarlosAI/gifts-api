# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


3.times { User.create!(name: Faker::Name.name, email: Faker::Internet.email, token: Faker::Crypto.md5 ) }


50.times {
  user = User.all.sample
  School.create!(
    name: Faker::University.name,
    address: Faker::Address.full_address,
    user_id: user.id,
  )
}

10.times {
	user = User.all.sample
	school = School.all.sample
	Recipient.create!(
    name: Faker::University.name,
    address: Faker::Address.full_address,
    user_id: user.id,
    school_id: school.id
  )
}

Gift.create(gift_type: "HOODIE")
Gift.create(gift_type: "T_SHIRT")
Gift.create(gift_type: "STICKER")
Gift.create(gift_type: "MUG")


data = Recipient.last
user_id = User.last.id
Order.create(school_id: data.school_id, user_id: user_id)
order_id = Order.last.id
gift = Gift.all.sample
recipient = Recipient.all.sample
OrderDetail.create(order_id: order_id, gift_id: gift.id)
OrderRecipient.create(order_id: order_id, recipient_id: recipient.id)