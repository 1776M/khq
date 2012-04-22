class Basecase < ActiveRecord::Base

    attr_accessible :name, :total_debt

    belongs_to :group

    has_many :annuals
    has_many :borrowings
    has_many :rules
    has_many :inputs
    has_many :lookups

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

    def lookup_table(id)

        @annuals =  Annual.find(:all, :conditions => [" basecase_id = ?", id])
        @inputs =   Input.find(:all, :conditions => [" basecase_id = ?", id])

        lookup = Hash.new

        # create hash entry for each annual
        # create hash entry for each annual value

        @annuals.each do |annual|
            lookup[annual.name] = [annual.year_0, annual.year_1, annual.year_2, annual.year_3, annual.year_4, annual.year_5]
            lookup[annual.name + "." + "year_0"] = annual.year_0
            lookup[annual.name + "." + "year_1"] = annual.year_1
            lookup[annual.name + "." + "year_2"] = annual.year_2
            lookup[annual.name + "." + "year_3"] = annual.year_3
            lookup[annual.name + "." + "year_4"] = annual.year_4
            lookup[annual.name + "." + "year_5"] = annual.year_5 
        end

        # create hash entry for each input single
        # create hash entry for each input multi

        @inputs.each do |input|
           require 'csv'
           input.name = CSV.parse(input.name, :headers => true, :header_converters => :symbol) 
           
           if input.name.headers().count==2
               input.name.each do |row|   
                   lookup[row[0]] = row[1] 
               end 
           else 
               input.name.each do |row|
                   col_num = 0
                   while col_num < input.name.headers().count
                       lookup[row[0] + "." + row[col_num]] = row[col_num]
      
                       col_num = col_num + 1
                   end 
               end  

           end
        end
 
        return lookup    
     end

    def parse_code(input_string)
        
#       # explode string into new lines
#       input_string = input_string.split(/\r?\n/)

#       # create an array of rules
#       rules_array = []

#       # put all the rules into an array
#       input_string.each do |sub_rule|
#               rules_array << sub_rule                
#       end
  
#       # loop through the rules array and perform appropriate actions or call appropriate functions

#       rules_array.delete_if {|x| x == "" || x == " "}

       # string to record whether it is a rule or not
#       is_rule = 0  
       
       # head is the left had side of the equals sign, body is the right     
#       rule_head = ""
#       rule_body = ""

#       rules_array.each do |rule|

         # check if it contains an = sign
#         if rule.include? "="
#            is_rule = 1
#            rule_head = rule.split("=").first
#            rule_body = rule.split("=").last
#         end

         # create a look_up table/hash of all actors before running the parse_code function

         # find the actors on the right
         # split the actors, for each actor find_actor()

         # evaluate the rule but only allow certain operands and numbers, or an array containing numbers
         # eval(rule)

         # find the actor on the left
         # find_actor

         # update or create the actor on the left      
         # if exists update actor, else create actor

#       end
	
       return input_string     

    end

end
