class MatchesController < ApplicationController
  before_filter :authenticate_user!
  def index
    
  end

  def new
    if current_user.arenas.length == 0 || current_user.arenas.last.complete
      redirect_to new_arena_path, flash: {error: "You have no currently active Arena. Please create one here."}
    end
    @match = Match.new
  end

  def create
    match = Match.new(match_params)
    match.arena = current_user.arenas.last

    if match.save
      current_user.add_match_stats(match)

      redirect_to arenas_path, flash: {success: "Match results successfully added."}
    else
      render :new
    end
  end

  def edit
    @match = Match.find(params[:id])
  end

  def update
    match = Match.find(params[:id])
    enemy = match.enemy
    first = match.first
    win = match.win

    match.update match_params

    #Need to -= 1 from all the previous values so:
    User.remove_match_stats(enemy, first, win, match, current_user)

    if match.save
      current_user.add_match_stats(match)

      redirect_to arenas_path, flash: {success: "Match results successfully updated."}
    else
      render :new
    end
  end

  private

  def match_params
    params.require(:match).permit(:win, :enemy, :first)
  end
end
