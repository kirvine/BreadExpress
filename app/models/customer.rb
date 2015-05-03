class Customer < ActiveRecord::Base
  # get module to help with some functionality
  include BreadExpressHelpers::Validations
  
  # Relationships
  has_many :orders
  has_many :addresses
  belongs_to :user
  
  accepts_nested_attributes_for :user, reject_if: ->(user) { user[:username].blank? }, allow_destroy: true

  # Scopes
  scope :alphabetical,  -> { order(:last_name).order(:first_name) }
  scope :active,        -> { where(active: true) }
  scope :inactive,      -> { where(active: false) }
  
  # Validations
  validates_presence_of :last_name, :first_name
  validates_format_of :phone, with: /\A(\d{10}|\(?\d{3}\)?[-. ]\d{3}[-.]\d{4})\z/, message: "should be 10 digits (area code needed) and delimited with dashes only"
  validates_format_of :email, with: /\A[\w]([^@\s,;]+)@(([\w-]+\.)+(com|edu|org|net|gov|mil|biz|info))\z/i, message: "is not a valid format"

  # Callbacks
  before_save :reformat_phone
  before_update :deactive_user_if_customer_inactive
  before_destroy :is_never_destroyable

  # Other methods
  def name
    "#{last_name}, #{first_name}"
  end

  def proper_name
    "#{first_name} #{last_name}"
  end

  # # For map of addresses
  # def address
  # [ street, city, state, country].compact.join(', ')
  # end

  # def create_map_link(zoom=12,width=800,height=800)
  #   markers = ""; i = 1
  #   self.addresses.by_recipient.to_a.each do |attr|
  #   markers += "&markers=color:red%7Ccolor:red%7Clabel:#{i}%7C#{attr.latitude},#{attr.longitude}"
  #   i += 1
  #   end
  #   map = "http://maps.google.com/maps/api/staticmap?center= #{latitude},#{longitude}&zoom=#{zoom}&size=#{width}x#{height}&maptype=roadmap&sensor=false"+markers
  # end

  # def find_town_coordinates
  #   coord = Geocoder.coordinates("#{name}, #{state}")
  #   if coord
  #     self.latitude = coord[0]
  #     self.longitude = coord[1]
  #   else 
  #     errors.add(:base, "Error with geocoding")
  #   end
  #   coord
  # end

  # Private methods
  private
  def reformat_phone
    self.phone = self.phone.to_s.gsub(/[^0-9]/,"")
  end

  def deactive_user_if_customer_inactive
    if !self.active && !self.user.nil?
      self.user.active = false
      self.user.save
    end
  end
end
