class Actborrowing < ActiveRecord::Base

    attr_accessible :size, :coupon, :issue_year, :maturity_year, :currency, :fixed_float, :top_borrowing 

    belongs_to :scenario

    validates :size,           :presence => true
    validates :coupon,         :presence => true
    validates :issue_year,     :presence => true
    validates :maturity_year,  :presence => true
    validates :currency,       :presence => true
    validates :fixed_float,    :presence => true
    validates :scenario_id,    :presence => true


end
