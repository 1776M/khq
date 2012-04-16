class RenameTopAnnualTopCurrency < ActiveRecord::Migration
  def up
    rename_column :actcurrencies, :top_annual, :top_currency
  end

  def down
  end
end
