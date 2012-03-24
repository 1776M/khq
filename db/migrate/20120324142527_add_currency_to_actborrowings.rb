class AddCurrencyToActborrowings < ActiveRecord::Migration
  def change
    add_column :actborrowings, :currency, :string, default: 'EUR'
  end
end
