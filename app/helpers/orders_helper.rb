module OrdersHelper
  # create a helper to get the options for the order select menu
  # will return an array with key being recipient : street_1
  def get_address_options
  	if current_user.role?(:admin)
    	return Address.active.by_recipient.map{|a| ["#{a.recipient} : #{a.street_1}", a.id] }
    else
    	return current_user.customer.addresses.active.by_recipient.map{|a| ["#{a.recipient} : #{a.street_1}", a.id] }
    end
  end
end
