class AddNameToAnnuals < ActiveRecord::Migration
  def change
    add_column :annuals, :name, :string, default: "EBITDA"
  end
end
