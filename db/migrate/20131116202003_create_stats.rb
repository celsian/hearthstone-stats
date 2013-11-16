class CreateStats < ActiveRecord::Migration
  def change
    create_table :stats do |t|
      t.references :user, index: true
      t.integer :wins
      t.integer :losses
      t.integer :winrate_when_first_wins
      t.integer :winrate_when_first_losses
      t.integer :winrate_when_second_wins
      t.integer :winrate_when_second_losses

      t.integer :total_series
      t.integer :profitable_series
      t.integer :nine0
      t.integer :ninex
      t.integer :xthree
      t.integer :zerothree

      t.integer :wr_as_druid_wins
      t.integer :wr_as_druid_losses
      t.integer :wr_as_hunter_wins
      t.integer :wr_as_hunter_losses
      t.integer :wr_as_mage_wins
      t.integer :wr_as_mage_losses
      t.integer :wr_as_paladin_wins
      t.integer :wr_as_paladin_losses
      t.integer :wr_as_priest_wins
      t.integer :wr_as_priest_losses
      t.integer :wr_as_shaman_wins
      t.integer :wr_as_shaman_losses
      t.integer :wr_as_rogue_wins
      t.integer :wr_as_rogue_losses
      t.integer :wr_as_warlock_wins
      t.integer :wr_as_warlock_losses
      t.integer :wr_as_warrior_wins
      t.integer :wr_as_warrior_losses

      t.integer :wr_against_druid_wins
      t.integer :wr_against_druid_losses
      t.integer :wr_against_hunter_wins
      t.integer :wr_against_hunter_losses
      t.integer :wr_against_mage_wins
      t.integer :wr_against_mage_losses
      t.integer :wr_against_paladin_wins
      t.integer :wr_against_paladin_losses
      t.integer :wr_against_priest_wins
      t.integer :wr_against_priest_losses
      t.integer :wr_against_shaman_wins
      t.integer :wr_against_shaman_losses
      t.integer :wr_against_rogue_wins
      t.integer :wr_against_rogue_losses
      t.integer :wr_against_warlock_wins
      t.integer :wr_against_warlock_losses
      t.integer :wr_against_warrior_wins
      t.integer :wr_against_warrior_losses

      t.timestamps
    end
  end
end
