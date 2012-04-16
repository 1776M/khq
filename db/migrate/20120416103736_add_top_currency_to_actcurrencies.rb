class AddTopCurrencyToActcurrencies < ActiveRecord::Migration
  def change
    add_column :actcurrencies, :top_annual, :integer
  end
end
