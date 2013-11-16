class MatchesController < ApplicationController
  def index

  end

  def new
    @match = Match.new
  end

  def create
    match = Match.new(match_params)
    match.arena = current_user.arenas.last

    if match.save
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
