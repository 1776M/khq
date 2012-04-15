class AddTopAnnualToActannuals < ActiveRecord::Migration
  def change
    add_column :actannuals, :top_annual, :integer
  end
end
