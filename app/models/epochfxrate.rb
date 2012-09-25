class Epochfxrate < ActiveRecord::Base
 
    attr_accessible :currency_pair, :rate, :year

    validates :currency_pair,     :presence => true
    validates :rate,              :presence => true
    validates :year,              :presence => true
 
end
