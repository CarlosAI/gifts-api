json.array! @orders do |order|
  json.id order.id
  json.status order.status
  json.created_by_user do
  	json.id order.user_id
  	json.name order.user.name
  end
  json.school_info do
  	json.id order.school_id
  	json.name order.school.name
  	json.address order.school.address
  end
  json.recipients order.order_recipients do |rec|
  	json.id rec.recipient_id
  	json.name rec.recipient.name
  end
  json.gifts order.order_details do |ord_det|
  	json.id ord_det.gift_id
  	json.type ord_det.gift.gift_type
  	json.description ord_det.gift.description
  end
end