class Address < ApplicationRecord
  validates_presence_of :address, :city, :state, :zip
  belongs_to :user
end
