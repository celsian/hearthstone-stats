class AddBestKeyToStats < ActiveRecord::Migration
  def change
    add_column :stats, :best_key, :integer
  end
end