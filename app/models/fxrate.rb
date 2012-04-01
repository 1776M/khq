class Fxrate < ActiveRecord::Base

    attr_accessible :currency_pair, :rate_year_0, :rate_year_1, :rate_year_2, :rate_year_3, :rate_year_4, :rate_year_5, :volatility, :correlation 		

    validates :currency_pair,     :presence => true
    validates :rate_year_0,     :presence => true
    validates :rate_year_1,     :presence => true
    validates :rate_year_2,     :presence => true
    validates :rate_year_3,     :presence => true
    validates :rate_year_4,     :presence => true
    validates :rate_year_5,     :presence => true
    validates :volatility,     :presence => true
    validates :correlation,     :presence => true

end
