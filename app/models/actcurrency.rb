class Actcurrency < ActiveRecord::Base

    attr_accessible :currency_name, :year_0, :year_1, :year_2, :year_3, :year_4, :year_5, :top_currency 		

    belongs_to :actannual

    validates :currency_name, :presence => true
    validates :year_0,     :presence => true
    validates :year_1,     :presence => true
    validates :year_2,     :presence => true
    validates :year_3,     :presence => true
    validates :year_4,     :presence => true
    validates :year_5,     :presence => true

    validates :actannual_id,  :presence => true


end
