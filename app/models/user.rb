class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  #My Input
  has_many :arenas
  has_many :matches, through: :arenas

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
      winrate = "#{((total_score.to_f/matches.length).round(4)*100)}%"
    else
      "N/A"
    end
  end

  def winrate_turn
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

    return [["W: #{firstw} L: #{first-firstw}", "#{((firstw.to_f/first).round(4)*100)}%"],["W: #{secondw} L: #{second-secondw}", "#{((secondw.to_f/second).round(4)*100)}%"]]

  end

end
