class Scenario < ActiveRecord::Base

    attr_accessible :name

    belongs_to :project
  
    # has_many :actannuals
    # has_many :actborrowings
    has_many :basecases, :through => :project

    validates :name,       :presence => true
    validates :project_id, :presence => true


    #def total_debt(id) 
    #    total = Actborrowing.find_by_sql(["Select * from Actborrowings where scenario_id=?",id])
    #end

    
    #def fixed_percent(id) 
    #    fixed = Actborrowing.find_by_sql(["Select * from Actborrowings where scenario_id=? and fixed_float=?",id,"Fixed"])
    #end

    #def macaulay_duration(id)
    #    total_duration = 0
    #    duration = 0
    #    int_rate = 0.05
        
    #    @total = Actborrowing.find_by_sql(["Select * from Actborrowings where scenario_id=?",id])
    #    @total.each do | bond |
    #        term = bond.maturity_year - Time.now.year  
    #        i = 0 
    #        begin    
            
    #             duration = duration + (bond.size * bond.coupon* i) / ((1 + int_rate)**i)  
    #             i = i + 1  
    #       end while i < term
            
    #       duration = duration + (term * bond.size)
    #       duration = duration / ((bond.size * bond.coupon) * ((1 - (1+int_rate)**(0-term))/int_rate) + (bond.size/((1+int_rate)**term)))
          
    #       total_duration = total_duration + (duration * bond.size)
    #    end
    #       return total_duration      
    #end

end
