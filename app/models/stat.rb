class Stat < ActiveRecord::Base
  belongs_to :user

  after_create :init

  def init
      self.wins ||= 0
      self.losses ||= 0
      self.winrate_when_first_wins ||= 0
      self.winrate_when_first_losses ||= 0
      self.winrate_when_second_wins ||= 0
      self.winrate_when_second_losses ||= 0

      self.total_series ||= 0
      self.profitable_series ||= 0
      self.nine0 ||= 0
      self.ninex ||= 0
      self.xthree ||= 0
      self.zerothree ||= 0

      self.wr_as_druid_wins ||= 0
      self.wr_as_druid_losses ||= 0
      self.wr_as_hunter_wins ||= 0
      self.wr_as_hunter_losses ||= 0
      self.wr_as_mage_wins ||= 0
      self.wr_as_mage_losses ||= 0
      self.wr_as_paladin_wins ||= 0
      self.wr_as_paladin_losses ||= 0
      self.wr_as_priest_wins ||= 0
      self.wr_as_priest_losses ||= 0
      self.wr_as_shaman_wins ||= 0
      self.wr_as_shaman_losses ||= 0
      self.wr_as_rogue_wins ||= 0
      self.wr_as_rogue_losses ||= 0
      self.wr_as_warlock_wins ||= 0
      self.wr_as_warlock_losses ||= 0
      self.wr_as_warrior_wins ||= 0
      self.wr_as_warrior_losses ||= 0

      self.wr_against_druid_wins ||= 0
      self.wr_against_druid_losses ||= 0
      self.wr_against_hunter_wins ||= 0
      self.wr_against_hunter_losses ||= 0
      self.wr_against_mage_wins ||= 0
      self.wr_against_mage_losses ||= 0
      self.wr_against_paladin_wins ||= 0
      self.wr_against_paladin_losses ||= 0
      self.wr_against_priest_wins ||= 0
      self.wr_against_priest_losses ||= 0
      self.wr_against_shaman_wins ||= 0
      self.wr_against_shaman_losses ||= 0
      self.wr_against_rogue_wins ||= 0
      self.wr_against_rogue_losses ||= 0
      self.wr_against_warlock_wins ||= 0
      self.wr_against_warlock_losses ||= 0
      self.wr_against_warrior_wins ||= 0
      self.wr_against_warrior_losses ||= 0
  end

  def self.perc(a, b)
    if a == 0 && b == 0
      return "N/A"
    else
      return "#{((a.to_f/(a+b))*100).round(2)}%"
    end
  end

end
