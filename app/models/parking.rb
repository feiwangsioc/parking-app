class Parking < ApplicationRecord
  
  validates_presence_of :parking_type, :start_at
  validates_inclusion_of :parking_type, :in => ["guest", "short-term", "long-term"]
  belongs_to :user, optional: true

  validate :validate_end_at_with_amount

  def validate_end_at_with_amount
    if ( end_at.present? && amount.blank? )
      errors.add(:amount, "Must has amount")
    end

    if ( end_at.blank? && amount.present? )
      errors.add(:end_at, "Must has end-time")
    end
  end
  
  def duration
    ( end_at - start_at ) / 60
  end 
  
  def calculate_amount
    factor = (self.user.present?)? 50 : 100
    if self.amount.blank? && self.start_at.present? && self.end_at.present?
      if duration <= 60
      
        self.amount = 200 
      else 
        self.amount = 200 + ((duration - 60).to_f / 30).ceil * factor
      end 
    end 
  end 
  
end
