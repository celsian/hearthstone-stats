class ArenasController < ApplicationController
  before_filter :authenticate_user!
  def index
    @arena = Arena.current_arena(current_user)

    if @arena
      @arena_score = @arena.score_formatted
    end

    @overall = current_user.total_wins
    @overall_winrate = current_user.winrate

    winrate_turn = current_user.winrate_turn
    @first_winrate = winrate_turn.first.first
    @first_winrate_percentage = winrate_turn.first.last
    @second_winrate = winrate_turn.last.first
    @second_winrate_percentage = winrate_turn.last.last

  end

  def new
    @arena = Arena.new
  end

  def create
    arena = Arena.new(arena_params)
    arena.user = current_user
    if arena.save
      redirect_to arenas_path, flash: {success: "Arena started successfully."}
    else
      render :new
    end
  end

  private

  def arena_params
    params.require(:arena).permit(:hero, :user)
  end

end
