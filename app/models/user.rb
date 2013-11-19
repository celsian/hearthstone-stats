class User < ActiveRecord::Base
  #ATTENTION:
  #ATTENTION:
  #ATTENTION:
  #ATTENTION: Obsolete code should be removed after all User's have logged in at least once.
  #ATTENTION: Earliest valid login for removing obsolete code is: 11-16-2013 4:00PM PST
  #ATTENTION: Heroku Server runs on GMT 0 so 11-16-2013 23:55
  #ATTENTION:
  #ATTENTION:

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  #My Input
  after_initialize :init

  has_many :arenas, dependent: :destroy
  has_many :matches, through: :arenas
  has_one :stat, dependent: :destroy

  validates :username, uniqueness: true
  validates :username, presence: true

  before_save { |user| user.username = user.username.downcase }

  def init
    Stat.create(user: self)
  end

  def add_match_stats(match)
    if match.win
      stat.wins += 1
      if match.first
        stat.winrate_when_first_wins += 1
      else
        stat.winrate_when_second_wins += 1
      end

      str1 = "wr_as_" + match.arena.hero.downcase + "_wins"
      stat[str1] += 1

      str2 = "wr_against_" + match.enemy.downcase + "_wins"
      stat[str2] += 1
    else
      stat.losses += 1
      if match.first
        stat.winrate_when_first_losses += 1
      else
        stat.winrate_when_second_losses += 1
      end

      str1 = "wr_as_" + match.arena.hero.downcase + "_losses"
      stat[str1] += 1

      str2 = "wr_against_" + match.enemy.downcase + "_losses"
      stat[str2] += 1
    end
    stat.save #commit changes to the DB
  end

  def check_arena_complete
    if arenas.length > 0 && arenas.last.complete
      if arenas.last.score == 0
        stat["zerothree"] += 1
      elsif arenas.last.score == 9 && arenas.last.matches.length == 9
        stat["nine0"] += 1
        stat["profitable_series"] += 1
      elsif arenas.last.score == 9 && arenas.last.matches.length > 9
        stat["ninex"] += 1
        stat["profitable_series"] += 1
      elsif arenas.last.score < 9 && arenas.last.score >= 7
        stat["profitable_series"] += 1
      elsif arenas.last.score < 7
        stat["xthree"] += 1
      end
      arenas.last.destroy
      stat.save
    end
  end

  def add_arena_count
    stat.total_series += 1
    stat.save #commit changes to the DB
  end

############################################################################
# OBSOLETE CODE BELOW. (To be deleted after all users have a "stat" object)
############################################################################
#checks every time, but only grabs all the values once.
  def check_for_stats
    if !self.stat
      statistics = Stat.new(user: self)
      statistics.wins = self.total_score || 0
      if self.matches.length > 0
        statistics.losses = self.matches.length-statistics.wins

          winrate_turn_new = self.winrate_turn_new

        statistics.winrate_when_first_wins = winrate_turn_new[0][1]
        statistics.winrate_when_first_losses = winrate_turn_new[0][0]-winrate_turn_new[0][1]
        statistics.winrate_when_second_wins = winrate_turn_new[1][1]
        statistics.winrate_when_second_losses = winrate_turn_new[1][0]-winrate_turn_new[1][1]

          series_stats = self.series_stats_new

        statistics.total_series = self.arenas.length
        statistics.profitable_series = series_stats[2]
        statistics.nine0 = series_stats[0]
        statistics.ninex = series_stats[1]
        statistics.xthree = series_stats[3]
        statistics.zerothree = series_stats[4]

          as_class = self.winrate_as_class
          against_class = self.winrate_against_class

        statistics.wr_as_druid_wins = as_class["DruidW"]
        statistics.wr_as_druid_losses = as_class["Druid"]-as_class["DruidW"]
        statistics.wr_as_hunter_wins = as_class["HunterW"]
        statistics.wr_as_hunter_losses = as_class["Hunter"]-as_class["HunterW"]
        statistics.wr_as_mage_wins = as_class["MageW"]
        statistics.wr_as_mage_losses = as_class["Mage"]-as_class["MageW"]
        statistics.wr_as_paladin_wins = as_class["PaladinW"]
        statistics.wr_as_paladin_losses = as_class["Paladin"]-as_class["PaladinW"]
        statistics.wr_as_priest_wins = as_class["PriestW"]
        statistics.wr_as_priest_losses = as_class["Priest"]-as_class["PriestW"]
        statistics.wr_as_shaman_wins = as_class["ShamanW"]
        statistics.wr_as_shaman_losses = as_class["Shaman"]-as_class["ShamanW"]
        statistics.wr_as_rogue_wins = as_class["RogueW"]
        statistics.wr_as_rogue_losses = as_class["Rogue"]-as_class["RogueW"]
        statistics.wr_as_warlock_wins = as_class["WarlockW"]
        statistics.wr_as_warlock_losses = as_class["Warlock"]-as_class["WarlockW"]
        statistics.wr_as_warrior_wins = as_class["WarriorW"]
        statistics.wr_as_warrior_losses = as_class["Warrior"]-as_class["WarriorW"]

        statistics.wr_against_druid_wins = against_class["DruidW"]
        statistics.wr_against_druid_losses = against_class["Druid"]-against_class["DruidW"]
        statistics.wr_against_hunter_wins = against_class["HunterW"]
        statistics.wr_against_hunter_losses = against_class["Hunter"]-against_class["HunterW"]
        statistics.wr_against_mage_wins = against_class["MageW"]
        statistics.wr_against_mage_losses = against_class["Mage"]-against_class["MageW"]
        statistics.wr_against_paladin_wins = against_class["PaladinW"]
        statistics.wr_against_paladin_losses = against_class["Paladin"]-against_class["PaladinW"]
        statistics.wr_against_priest_wins = against_class["PriestW"]
        statistics.wr_against_priest_losses = against_class["Priest"]-against_class["PriestW"]
        statistics.wr_against_shaman_wins = against_class["ShamanW"]
        statistics.wr_against_shaman_losses = against_class["Shaman"]-against_class["ShamanW"]
        statistics.wr_against_rogue_wins = against_class["RogueW"]
        statistics.wr_against_rogue_losses = against_class["Rogue"]-against_class["RogueW"]
        statistics.wr_against_warlock_wins = against_class["WarlockW"]
        statistics.wr_against_warlock_losses = against_class["Warlock"]-against_class["WarlockW"]
        statistics.wr_against_warrior_wins = against_class["WarriorW"]
        statistics.wr_against_warrior_losses = against_class["Warrior"]-against_class["WarriorW"]

        #Clear old arena's. (DB Management)
        arenas.each do |arena|
          if arena.complete
            arena.destroy
          end
        end

      end
      statistics.save
    end
  end

  def series_stats_new
    if arenas.length > 0 && arenas.first.complete == true
      ninezero = 0
      ninex = 0
      sevenprofitable = 0
      xthree = 0
      xzero = 0

      arenas.each do |arena|
        if arena.complete
          if arena.score == 9 && arena.matches.length == 9
            ninezero += 1
            sevenprofitable += 1
          elsif arena.score == 9 && arena.matches.length > 9
            ninex += 1
            sevenprofitable += 1
          elsif arena.score < 9 && arena.score >= 7
            sevenprofitable += 1
          elsif arena.score < 7
            xthree += 1
          elsif arena.score == 0
            xzero += 1
          end
        end
      end
      return [ninezero, ninex, sevenprofitable, xthree, xzero]
    else
      return [0,0,0,0,0]
    end
  end

  def winrate_turn_new
    if matches.length > 0
      first = 0
      firstw = 0
      second = 0
      secondw = 0

      matches.each do |match|
        if match.first
          first += 1
          if match.win
            firstw += 1
          end
        else
          second += 1
          if match.win
            secondw += 1
          end
        end
      end

      return [[first,firstw],[second,secondw]]
    else
      return [[0,0],[0,0]]
    end
  end


  def total_wins
    score = total_score
    if score
      return "W: #{score} L: #{matches.length-score}"
    else
      return "No Games Played"
    end
  end

  def total_score
    if arenas.length > 0
      win = 0
      if matches.length > 0
        matches.each do |match|
          if match.win
            win += 1
          end
        end
        return win
      end
    end
  end

  def winrate
    if arenas.first && arenas.first.matches.length > 0
      winrate = "#{((total_score.to_f/matches.length)*100).round(2)}%"
    else
      "N/A"
    end
  end

  def winrate_turn
    if arenas.first && arenas.first.matches.length > 0
      first = 0
      firstw = 0
      second = 0
      secondw = 0

      matches.each do |match|
        if match.first
          first += 1
          if match.win
            firstw += 1
          end
        else
          second += 1
          if match.win
            secondw += 1
          end
        end
      end

      return [["W: #{firstw} L: #{first-firstw}", "#{((firstw.to_f/first)*100).round(2)}%"],["W: #{secondw} L: #{second-secondw}", "#{((secondw.to_f/second)*100).round(2)}%"]]
    else
      return [["N/A", "N/A"],["N/A", "N/A"]]
    end
  end

  def series_stats
    if arenas.length > 0 && arenas.first.complete == true
      ninezero = 0
      ninex = 0
      sevenprofitable = 0
      xthree = 0
      xzero = 0

      arenas.each do |arena|
        if arena.complete
          if arena.score == 9 && arena.matches.length == 9
            ninezero += 1
            sevenprofitable += 1
          elsif arena.score == 9 && arena.matches.length > 9
            ninex += 1
            sevenprofitable += 1
          elsif arena.score < 9 && arena.score >= 7
            sevenprofitable += 1
          elsif arena.score < 7
            xthree += 1
          elsif arena.score == 0
            xzero += 1
          end
        end
      end
      return [[sevenprofitable, "#{((sevenprofitable.to_f/arenas.length)*100).round(2)}%"], [ninezero, "#{((ninezero.to_f/arenas.length)*100).round(2)}%"], [ninex, "#{((ninex.to_f/arenas.length)*100).round(2)}%"], [xthree, "#{((xthree.to_f/arenas.length)*100).round(2)}%"], [xzero, "#{((xzero.to_f/arenas.length)*100).round(2)}%"]]
    else
      return [["N/A", "N/A"], ["N/A", "N/A"], ["N/A", "N/A"], ["N/A", "N/A"], ["N/A", "N/A"]]
    end
  end

  def winrate_as_class
    classes = { "Druid" => 0, "Hunter" => 0, "Mage" => 0, "Paladin" => 0, "Priest" => 0,
      "Shaman" => 0, "Rogue" => 0, "Warlock" => 0, "Warrior" => 0, "DruidW" => 0, "HunterW" => 0,
      "MageW" => 0, "PaladinW" => 0, "PriestW" => 0, "ShamanW" => 0, "RogueW" => 0,
      "WarlockW" => 0, "WarriorW" => 0, "DruidP" => 0, "HunterP" => 0, "MageP" => 0, "PaladinP" => 0,
      "PriestP" => 0, "ShamanP" => 0, "RogueP" => 0, "WarlockP" => 0, "WarriorP" => 0}

    if matches.length > 0
      matches.each do |match|
        classes[match.arena.hero] += 1
        if match.win
          classes[match.arena.hero+"W"] += 1
        end
      end
    end

    classes["DruidP"] = User.percentage(classes, "Druid")
    classes["HunterP"] = User.percentage(classes, "Hunter")
    classes["MageP"] = User.percentage(classes, "Mage")
    classes["PaladinP"] = User.percentage(classes, "Paladin")
    classes["PriestP"] = User.percentage(classes, "Priest")
    classes["ShamanP"] = User.percentage(classes, "Shaman")
    classes["RogueP"] = User.percentage(classes, "Rogue")
    classes["WarlockP"] = User.percentage(classes, "Warlock")
    classes["WarriorP"] = User.percentage(classes, "Warrior")

    return classes
  end

  def winrate_against_class
    classes = { "Druid" => 0, "Hunter" => 0, "Mage" => 0, "Paladin" => 0, "Priest" => 0,
      "Shaman" => 0, "Rogue" => 0, "Warlock" => 0, "Warrior" => 0, "DruidW" => 0, "HunterW" => 0,
      "MageW" => 0, "PaladinW" => 0, "PriestW" => 0, "ShamanW" => 0, "RogueW" => 0,
      "WarlockW" => 0, "WarriorW" => 0, "DruidP" => 0, "HunterP" => 0, "MageP" => 0, "PaladinP" => 0,
      "PriestP" => 0, "ShamanP" => 0, "RogueP" => 0, "WarlockP" => 0, "WarriorP" => 0}

    if matches.length > 0
      matches.each do |match|
        classes[match.enemy] += 1
        if match.win
          classes[match.enemy+"W"] += 1
        end
      end
    end

    classes["DruidP"] = User.percentage(classes, "Druid")
    classes["HunterP"] = User.percentage(classes, "Hunter")
    classes["MageP"] = User.percentage(classes, "Mage")
    classes["PaladinP"] = User.percentage(classes, "Paladin")
    classes["PriestP"] = User.percentage(classes, "Priest")
    classes["ShamanP"] = User.percentage(classes, "Shaman")
    classes["RogueP"] = User.percentage(classes, "Rogue")
    classes["WarlockP"] = User.percentage(classes, "Warlock")
    classes["WarriorP"] = User.percentage(classes, "Warrior")

    return classes
  end

  def self.percentage(hash, s)
    return hash[s] != 0 ? "#{(hash[s+"W"]/hash[s].to_f*100).round(2)}%" : "N/A"
  end
############################################################################
# END OBSOLETE CODE
############################################################################
end

class User::ParameterSanitizer < Devise::ParameterSanitizer
  def sign_in
    default_params.permit(:username, :email)
  end
end