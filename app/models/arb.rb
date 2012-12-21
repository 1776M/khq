class Arb < ActiveRecord::Base

  attr_accessible :name

  serialize :name, Hash

  belongs_to :basecase

  validates :name,       :presence => true
  validates :basecase_id,  :presence => true

  attr_accessible :basecase_id, :name
end
