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

  private

  def match_params
    params.require(:match).permit(:win, :enemy, :first)
  end
end
