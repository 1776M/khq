class Sense < ActiveRecord::Base

  attr_accessible :name

  belongs_to :face

  validates :name, :presence => true
  validates :face_id,  :presence => true

end
