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
           input.body = CSV.parse(input.body, :headers => true, :header_converters => :symbol) 
           
           if input.body.headers().count==2
               input.body.each do |row|   
                   lookup[row[0]] = row[1] 
               end 
           else 
               input.body.each do |row|
                   col_num = 0
                   while col_num < input.body.headers().count
                       lookup[row[0] + "." + input.body.headers[col_num].to_s] = row[col_num]
      
                       col_num = col_num + 1
                   end 
               end  

           end
        end
 
        return lookup    
     end

     def create_lookuptable(id)

         params = Hash.new
         @basecase = Basecase.find(id) 

         params[:lookup] = {
     
             name: @basecase.lookup_table(id),
             basecase_id: id
             }
     
         if @basecase.lookups.count < 1  

             @lookup = @basecase.lookups.build(params[:lookup]) 
                 if @lookup.save  
                     # this is just a dummy variable to do something in the loop
                     a = 1
                 end 
         end

      end

     def update_lookuptable(id, lookup_array)

         params = Hash.new
         @basecase = Basecase.find(id) 

         params[:lookup] = {
     
             name: lookup_array,
             basecase_id: id
             }
     
             @lookup = Lookup.find(:last, :conditions => [" basecase_id = ?", id]) 
                 if @lookup.update_attributes(params[:lookup])
                     # this is just a dummy variable to do something in the loop
                     a = 1
                 end   
      end


    def parse_code(input_string, id)
        
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
     
       # pull out the lookup_array
       @lookup = Lookup.find(:last, :conditions => [" basecase_id = ?", id])
       lookup_array = @lookup.name

       # array to hold true/false of whether each actor is an array or not
       type_check = []

       # sets to 1 if rules contains array  
       rule_contains_array = 0

       # holds the max length of any array within a single rule
       max_array_length = 0

       rules_array.each do |rule|

         # check if it contains an = sign
         if rule.include? "="
            is_rule = 1
            rule_head = rule.split("=").first
            rule_body = rule.split("=").last
         end

         # first replace all + - * / ( ) with a space before and after it, if it does not exist

         if rule_body.include? "+"
             rule_body = rule_body.gsub(/[+]/, '+' => ' + ')
         end

         if rule_body.include? "-"
             rule_body = rule_body.gsub(/[-]/, '-' => ' - ')
         end

         if rule_body.include? "*"
             rule_body = rule_body.gsub(/[*]/, '*' => ' * ')
         end

         if rule_body.include? "/"
             rule_body = rule_body.gsub("/", '/' => ' / ')
         end

         if rule_body.include? "("
             rule_body = rule_body.gsub(/[(]/, '(' => ' ( ')
         end

         if rule_body.include? ")"
             rule_body = rule_body.gsub(/[)]/, ')' => ' ) ')
         end

         # replace all multiple white spaces with a single space
         rule_body = rule_body.squeeze(" ")

         # replace all actors with the items from the lookup table

         # add operators to lookup_array
         lookup_array["+"] = "+"
         lookup_array["-"] = "-"
         lookup_array["*"] = "*"
         lookup_array["/"] = "/"
         lookup_array["("] = "("
         lookup_array[")"] = ")"

         broken_string = rule_body.split(" ")

         # substitute the lookup table into the rule
         broken_string.each do |item|

             # need to check if any item is an array
             type_check << lookup_array[:"#{ item }"].kind_of?(Array)
             if type_check.include?(true)
                 rule_contains_array = 1
             end
 
             if lookup_array[:"#{ item }"].kind_of?(Array)
                 if lookup_array[:"#{ item }"].count > max_array_length  
                     max_array_length = lookup_array[:"#{ item }"].count
                 end
             end 


             # if there are no arrays in the formula then use the simple approach to calculations
             if max_array_length == 0
                 if lookup_array[:"#{ item }"]
                     value = lookup_array[:"#{ item }"] 
                     rule_body = rule_body.gsub("#{item}", "#{ value }" ) 
                 end
             end 

         end 
         

         # evaluate the rule but only allow certain operands and numbers, or an array containing numbers
         if max_array_length == 0
               rule_body = eval(rule_body)
#              rule_body = 
#              lookup_array["#{ rule_head }"] = rule_body
#             update_lookuptable(id, lookup_array)   
         end

         # find the actor on the left
         # find_actor

         # update or create the actor on the left      
         # if exists update actor, else create actor

       end
	
       return rule_body     

    end

end
