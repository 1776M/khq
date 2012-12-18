class Dashboard < ActiveRecord::Base

  attr_accessible :name

  belongs_to :basecase
  has_many :faces

  validates :name, :presence => true
  validates :basecase_id,  :presence => true



end
