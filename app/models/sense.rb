class Sense < ActiveRecord::Base

  attr_accessible :name

  belongs_to :face

  validates :name, :presence => true
  validates :face_id,  :presence => true


  def parse_sense(name)
      
      # this splits the name into an array of parts
      the_string_as_array = name.split(' ')
 
      return the_string_as_array
  end

end
