class Ability
  include CanCan::Ability
  
  def initialize(user)
    # set user to new User if not logged in
    user ||= User.new # i.e., a guest user
    
    # set authorizations for different user roles
    if user.role? :admin
      # they get to do it all
      can :manage, :all

    elsif user.role? :customer
      # they can read their own profile
      can :show, Customer do |c|
        c.id == user.customer.id
      end

      # they can update their own profile
      can :update, Customer do |c|  
        c.id == customer.id
      end
    
      # can see a list of all items
      can :index, Item

      # can read about an item
      can :show, Item

      # can add item to cart
      can :add_item, Item

      # can view cart
      can :cart, Order

      # can view checkout page
      can :checkout, Order

      # can create a new order
      can :new, Order

      can :create, Order

      can :show, Order do |o|
        o.customer.id == user.customer.id
      end
      
    else
      can :create, User
      can :create, Customer
      can :read, :all
    end

  end
end