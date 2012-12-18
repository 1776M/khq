class Face < ActiveRecord::Base

  attr_accessible :name

  belongs_to :dashboard
  has_many :faces

  validates :name, :presence => true
  validates :dashboard_id,  :presence => true

end
