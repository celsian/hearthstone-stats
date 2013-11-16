class Arena < ActiveRecord::Base
  belongs_to :user
  has_many :matches, dependent: :destroy

  default_scope order("id")

  def self.current_arena(current_user)
    if current_user.arenas.length > 0

        wins = 0
        current_user.arenas.last.matches.each do |match|
          if match.win
            wins += 1
          end
        end
        if wins == 9 || current_user.arenas.last.matches.length-wins >= 3
          current_user.arenas.last.complete = true
          current_user.arenas.last.save
        end

      if !current_user.arenas.last.complete
        return current_user.arenas.last
      end
    end
  end

  def score
    if matches.length > 0
      win = 0
      matches.each do |match|
        if match.win
          win += 1
        end
      end
      return win
    end
  end

  def score_formatted
    if score
      return "W: #{score} L: #{matches.length-score}"
    else
      return "No Matches Played"
    end
  end

end
