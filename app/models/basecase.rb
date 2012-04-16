class Basecase < ActiveRecord::Base

    attr_accessible :name, :total_debt

    belongs_to :group

    has_many :annuals
    has_many :borrowings
    has_many :rules

    validates :name,     :presence => true
    validates :group_id, :presence => true


    def total_debt(id) 
         total = Borrowing.find_by_sql(["Select * from Borrowings where basecase_id=?",id])
    end

    
    def fixed_percent(id) 
        fixed = Borrowing.find_by_sql(["Select * from Borrowings where basecase_id=? and fixed_float=?",id,"Fixed"])
    end


    def macaulay_duration(id)
        total_duration = 0
        duration = 0
        int_rate = 0.05
        
        @total = Borrowing.find_by_sql(["Select * from Borrowings where basecase_id=?",id])
        @total.each do | bond |
            term = bond.maturity_year - Time.now.year  
            i = 0 
            begin    
            
                 duration = duration + (bond.size * bond.coupon* i) / ((1 + int_rate)**i)  
                 i = i + 1  
            end while i < term
            
           duration = duration + (term * bond.size)
           duration = duration / ((bond.size * bond.coupon) * ((1 - (1+int_rate)**(0-term))/int_rate) + (bond.size/((1+int_rate)**term)))
          
           total_duration = total_duration + (duration * bond.size)
        end
           return total_duration      
    end

end
