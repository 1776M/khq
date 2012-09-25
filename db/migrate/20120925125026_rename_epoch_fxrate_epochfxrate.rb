class RenameEpochFxrateEpochfxrate < ActiveRecord::Migration
  def change
        rename_table :epoch_fxrates, :epochfxrates
  end 
end
