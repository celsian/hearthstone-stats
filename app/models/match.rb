class Match < ActiveRecord::Base
  HEROES = ["Druid", "Hunter", "Mage", "Paladin", "Priest", "Rogue", "Shaman", "Warlock", "Warrior"]
  WIN = [["Win!", true], ["Loss :(", false]]
  TURN = [["First", true], ["Second", false]]

    default_scope order("id")

    belongs_to :arena

end
