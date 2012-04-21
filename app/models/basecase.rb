class Basecase < ActiveRecord::Base

    attr_accessible :name, :total_debt

    belongs_to :group

    has_many :annuals
    has_many :borrowings
    has_many :rules
    has_many :inputs


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

    def parse_code(input_string)
        
       # explode string into new lines
       input_string = input_string.split(/\r?\n/)

       # create an array of rules
       rules_array = []

       # put all the rules into an array
       input_string.each do |sub_rule|
               rules_array << sub_rule                
       end
  
       # loop through the rules array and perform appropriate actions or call appropriate functions

       rules_array.delete_if {|x| x == "" || x == " "}

       # string to record whether it is a rule or not
       is_rule = 0  
       
       # head is the left had side of the equals sign, body is the right     
       rule_head = ""
       rule_body = ""

       rules_array.each do |rule|

         # check if it contains an = sign
         if rule.include? "="
            is_rule = 1
            rule_head = rule.split("=").first
            rule_body = rule.split("=").last
         end

         # create a look_up table/hash of all actors before running the parse_code function

         # find the actors on the right
         # split the actors, for each actor find_actor()

         # evaluate the rule but only allow certain operands and numbers, or an array containing numbers
         # eval(rule)

         # find the actor on the left
         # find_actor

         # update or create the actor on the left      
         # if exists update actor, else create actor

       end
	
       return rule_body     

    end

end
