class Forwardcurve < ActiveRecord::Base

    attr_accessible :currency, :term, :year_0, :year_1, :year_2, :year_3, :year_4, :year_5, :year_6, :year_7, :year_8, :year_9, :year_10 

    validates :currency,  :presence => true
    validates :term,      :presence => true
    validates :year_0,     :presence => true
    validates :year_1,     :presence => true
    validates :year_2,     :presence => true
    validates :year_3,     :presence => true
    validates :year_4,     :presence => true
    validates :year_5,     :presence => true
    validates :year_6,     :presence => true
    validates :year_7,     :presence => true
    validates :year_8,     :presence => true
    validates :year_9,     :presence => true
    validates :year_10,     :presence => true

end
