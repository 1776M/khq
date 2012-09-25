class Epochdate < ActiveRecord::Base

    attr_accessible :currency, :start_year

    belongs_to :scenario

    validates :currency, :presence => true
    validates :start_year,     :presence => true

    validates :scenario_id,  :presence => true

  
end
