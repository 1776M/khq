class CreateForwardcurves < ActiveRecord::Migration
  def change
    create_table :forwardcurves do |t|
      t.string :currency
      t.float  :term
      t.float  :year_0
      t.float  :year_1
      t.float  :year_2
      t.float  :year_3
      t.float  :year_4
      t.float  :year_5
      t.float  :year_6
      t.float  :year_7
      t.float  :year_8
      t.float  :year_9
      t.float  :year_10 

      t.timestamps
    end
  end
end
