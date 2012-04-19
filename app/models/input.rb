class Input < ActiveRecord::Base

   attr_accessible :name, :body

   belongs_to :basecase

   validates :name, :presence => true
   validates :body, :presence => true

   validates :basecase_id,  :presence => true

end
