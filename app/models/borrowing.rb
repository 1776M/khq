class Borrowing < ActiveRecord::Base

    attr_accessible :size, :coupon, :issue_year, :maturity_year, :currency, :fixed_float 

    belongs_to :basecase

    validates :size,           :presence => true
    validates :coupon,         :presence => true
    validates :issue_year,     :presence => true
    validates :maturity_year,  :presence => true
    validates :currency,       :presence => true
    validates :fixed_float,    :presence => true
    validates :basecase_id,    :presence => true

end
