class Invoice < ApplicationRecord
  validates_presence_of :date
  validates_presence_of :value, :if => :received?

  def value
    if received?
      self[:value]
    else
      self[:value]
    end
  end
end
