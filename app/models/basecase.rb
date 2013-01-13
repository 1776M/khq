class Basecase < ActiveRecord::Base

    attr_accessible :name, :total_debt

    belongs_to :group

    has_many :annuals
    has_many :borrowings
    has_many :rules
    has_many :inputs
    has_many :lookups
    has_many :arbs
    has_many :dashboards

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

            # add the currencies to the lookup table 

            if annual.currencies.count > 0
              annual.currencies.each do |currency|
                lookup[annual.name + "." + currency.currency_name] = [(annual.year_0*currency.year_0).round(1), (annual.year_1*currency.year_1).round(1), (annual.year_2*currency.year_2).round(1),(annual.year_3*currency.year_3).round(1), (annual.year_4*currency.year_4).round(1), (annual.year_5*currency.year_5).round(1)]
              end
            end 

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

           # add the actual arrays from the input table to the lookups as well

           row_num = 0
           input.body.each do |row|
               lookup[row[0]] = input.body[row_num].fields

               # remove the first and last items (i.e the row name is first and basecase id value is last)
               lookup[row[0]].pop
               lookup[row[0]].shift

               arb_item = Arb.where("name = ? AND basecase_id = ?", row[0], id).last

               if arb_item
                 the_currency = arb_item.name[0]

                 arb_item.name.delete_at(1)
                 arb_item.name.delete_at(0)               

                 lookup[row[0] + "." + the_currency] = Array.new(input.body.headers().count){ |i| (arb_item[col_num] * row[col_num]).round(1) } 
               end

               row_num = row_num + 1
           end

        end
 
        return lookup    
     end

     # this is not used, lookup table is created within the basecase show page
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

     # this is not used, lookup table is updated within the basecase show page
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

       # head is the left hand side of the equals sign, body is the right     
       rule_head = ""
       rule_body = ""

       # rule_head_array is an array for holding results of summed arrays
       rule_head_array = []

       # rule_body_array is an array for holding results of summed arrays
       rule_body_array = []

       # array for holding non-array items as arrays, e.g + becomes +,+,+,+,+
       items_as_array = []

       # all parts of the broken string are arrays
       broken_string_as_array = []

       # broken_string_as_array is then sorted into a series of strings held in an array, to be evaluated
       strings_to_evaluate = []

       # this holds the evaluated strings after strings_to_evaluate
       evaluated_strings = []

       # this array holds all the evaluated_strings (i.e. the answers to each rule calculation)
       answers_array = []
       
       # pull out the lookup_array
       @lookup = Lookup.find(:last, :conditions => [" basecase_id = ?", id])
       lookup_array = @lookup.name

       # array to hold true/false of whether each actor is an array or not
       type_check = []

       # this tests which part of max_array_length the calc goes through
       test_var = 0

       rules_array.each do |rule|

         # holds the max length of any array within a single rule
         max_array_length = 0
    
         # have to reset this to empty, for each loop of the array
         broken_string_as_array = []

         # check if it contains an = sign
         if rule.include? "="
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

         # remove white space from end of string
         rule_head = rule_head.strip!

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

         # loop through the broken_string twice, first to find the max_array_length, then two convert all items to array or leave as items
         broken_string.each do |item|

             # find the max length of an array in the rule, under the assumption all arrays are the same length
             if lookup_array[:"#{ item }"].kind_of?(Array)
                 if lookup_array[:"#{ item }"].count > max_array_length  
                     max_array_length = lookup_array[:"#{ item }"].count
                 end
             end 

         end

         broken_string.each do |item|

             # if there are no arrays in the formula then use the simple approach to calculations
             if max_array_length == 0
                 if lookup_array[:"#{ item }"]
                     value = lookup_array[:"#{ item }"]
                     # need to add space before and after item so EBIT and EBITA aren't mixed up
                     # item = item + " " 
                     rule_body = rule_body.gsub("#{item}", "#{ value }" )
                     # need to remove the spaces from item again so rest of code is not screwed up
                     # item = item.strip!
  
                 end
             end 


             if max_array_length > 0
                 # need to convert each item in broken string into an array, so all items are an array

                 if lookup_array[:"#{ item }"].kind_of?(Array) != true && lookup_array[:"#{ item }"]
                     items_as_array = Array.new(max_array_length){|x| x = lookup_array[:"#{ item }"] }
                     # add these new items_as_array into broken_string_as_array
                     broken_string_as_array << items_as_array                  
                 end

                 if lookup_array[:"#{ item }"].kind_of?(Array) != true && lookup_array[:"#{ item }"].nil?
                     items_as_array = Array.new(max_array_length){|x| x = item  }
                     # add these new items_as_array into broken_string_as_array
                     broken_string_as_array << items_as_array                  
                 end

                 # add array items into the broken_string_as_array too
                 if lookup_array[:"#{ item }"].kind_of?(Array) 
                     broken_string_as_array << lookup_array[:"#{ item }"]
                 end
   
             end

         end 
         
         evaluated_strings = []

         # evaluate the rule but only allow certain operands and numbers, or an array containing numbers
         if max_array_length == 0
               # rule_body = eval(rule_body)

               # delete any previous elements in the array
               # evaluated_strings.delete_if {|x| x }
               evaluated_strings << eval(rule_body)               
 
               # need to add the rule head into the lookup array
               lookup_array[:"#{rule_head}"]  = eval(rule_body) 
               rule_head_array << rule_head
               rule_body_array << rule_body 
         end

         # evaluate the rule for arrays

         if max_array_length > 0
             # using the stackoverflow answer

             strings_to_evaluate = broken_string_as_array.transpose.map { |c| c.join } 
             
             strings_to_evaluate.each do |item|

                 # delete any previous elements in the array
                 # evaluated_strings.delete_if {|x| x }
                 evaluated_strings << eval(item)
                 lookup_array[:"#{rule_head}"]  = evaluated_strings
                 rule_head_array << rule_head 
                 rule_body_array << strings_to_evaluate
             end

         end

         answers_array << evaluated_strings

         # this is to get the calculated fields into the lookup_array 
         ### lookup_array[:rule_head_array] = rule_head_array
         ### lookup_array[:rule_body_array] = rule_body_array
         ### lookup_array[:rule_head_array] = lookup_array[:rule_head_array].uniq

       end
 	
       return lookup_array 

    end
    
end
