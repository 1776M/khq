class Dashboard < ActiveRecord::Base

  attr_accessible :name

  belongs_to :basecase

  validates :name, :presence => true
  validates :basecase_id,  :presence => true



end
