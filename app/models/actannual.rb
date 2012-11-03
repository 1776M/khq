class Actannual < ActiveRecord::Base

    attr_accessible :name, :year_0, :year_1, :year_2, :year_3, :year_4, :year_5, :top_annual 		

    belongs_to :scenario
    has_many :actcurrencies

    validates :name,       :presence => true
    validates :year_0,     :presence => true
    validates :year_1,     :presence => true
    validates :year_2,     :presence => true
    validates :year_3,     :presence => true
    validates :year_4,     :presence => true
    validates :year_5,     :presence => true

    validates :scenario_id,  :presence => true

    def self.save(upload)
      name =  upload['datafile'].original_filename
      directory = "public/assets"
      
      # create the file path
      path = File.join(directory, name)
    
      # write the file
      File.open(path, "wb") { |f| f.write(upload['datafile'].read) }
    end

end
