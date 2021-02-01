# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


3.times { User.create!(name: Faker::Name.name, email: Faker::Internet.email, token: Faker::Crypto.md5 ) }


50.times {
  users = User.all.sample
  School.create!(
    name: Faker::University.name,
    address: Faker::Address.full_address,
    user_id: users,
  )
}

10.times {
	users = User.all.sample
	schools = School.all.sample
	Recipient.create!(
    name: Faker::University.name,
    address: Faker::Address.full_address,
    user_id: users,
    school_id: schools
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
gifts = Gift.all.sample
recipients = Recipient.all.sample
OrderDetail.create(order_id: order_id, gift_id: gifts)
OrderRecipient.create(order_id: order_id, recipient_id: recipients)