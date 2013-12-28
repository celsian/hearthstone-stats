class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  #My Input
  after_create :init

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

  def self.remove_match_stats(enemy, first, win, match, current_user)
    if win
      current_user.stat.wins -= 1
      if first
        current_user.stat.winrate_when_first_wins -= 1
      else
        current_user.stat.winrate_when_second_wins -= 1
      end

      str1 = "wr_as_" + match.arena.hero.downcase + "_wins"
      current_user.stat[str1] -= 1

      str2 = "wr_against_" + enemy.downcase + "_wins"
      current_user.stat[str2] -= 1
    else
      current_user.stat.losses -= 1
      if first
        current_user.stat.winrate_when_first_losses -= 1
      else
        current_user.stat.winrate_when_second_losses -= 1
      end

      str1 = "wr_as_" + match.arena.hero.downcase + "_losses"
      current_user.stat[str1] -= 1

      str2 = "wr_against_" + enemy.downcase + "_losses"
      current_user.stat[str2] -= 1
    end
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
end

class User::ParameterSanitizer < Devise::ParameterSanitizer
  def sign_in
    default_params.permit(:username, :email)
  end
end