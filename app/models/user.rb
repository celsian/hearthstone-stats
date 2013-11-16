class User < ActiveRecord::Base

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  #My Input
  has_many :arenas
  has_many :matches, through: :arenas

  validates :username, uniqueness: true
  validates :username, presence: true

  before_save { |user| user.username = user.username.downcase }

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

end

class User::ParameterSanitizer < Devise::ParameterSanitizer
  def sign_in
    default_params.permit(:username, :email)
  end
end