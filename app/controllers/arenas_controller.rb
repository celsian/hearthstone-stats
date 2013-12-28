class ArenasController < ApplicationController
  before_filter :authenticate_user!

  def index
    @stats = current_user.stat

    @arena = Arena.current_arena(current_user)
    if @arena #Here to provide current arena stats only. Does not affect overall stats.
      @arena_score = @arena.score_formatted
    end

    current_user.check_arena_complete
  end

  def new
    @arena = Arena.new
  end

  def create
    arena = Arena.new(arena_params)
    arena.user = current_user
    if arena.save
      current_user.add_arena_count

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
