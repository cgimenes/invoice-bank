class Payment < ApplicationRecord
  belongs_to :company

  validates_presence_of :date
  validates_presence_of :company
  validates_presence_of :value
end
