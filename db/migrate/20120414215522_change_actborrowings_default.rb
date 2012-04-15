class ChangeActborrowingsDefault < ActiveRecord::Migration
  def up
    change_column_default :actborrowings, :currency, nil
  end

  def down
  end
end
