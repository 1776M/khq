class AddCurrencyToBorrowings < ActiveRecord::Migration
  def change
    add_column :borrowings, :currency, :string
  end
end
