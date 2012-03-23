class Project < ActiveRecord::Base


    attr_accessible :project_name

    belongs_to :user

    has_one :group, :through => :user
    # has_many :basescases, :through => :group
    # has_many :scenarios, :dependent => :destroy


    validates :project_name, :presence => true
    validates :user_id,      :presence => true

    default_scope :order => 'projects.created_at ASC'

end
