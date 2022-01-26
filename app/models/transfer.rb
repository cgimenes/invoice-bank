class Transfer < ApplicationRecord
  validates_presence_of :payments
  validates_presence_of :value
  validates_presence_of :date
end
