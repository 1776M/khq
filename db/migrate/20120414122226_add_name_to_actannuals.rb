class AddNameToActannuals < ActiveRecord::Migration
  def change
    add_column :actannuals, :name, :string, default: "EBITDA"
  end
end
