class Company < ApplicationRecord
  has_many :payments

  validates_presence_of :name
end
