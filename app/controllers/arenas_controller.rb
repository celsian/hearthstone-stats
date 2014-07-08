class ArenasController < ApplicationController
  before_filter :authenticate_user!

  def index
    @stats = current_user.stat

    @arena = Arena.current_arena(current_user)
    if @arena #Here to provide current arena stats only. Does not affect overall stats.
      @arena_score = @arena.score_formatted
      if @arena.score > (current_user.stat.best_key ||= 0)
        stat = current_user.stat
        stat.best_key = @arena.score
        stat.save
      end
    end

    current_user.check_arena_complete
  end

  def new
    @action = params[:action]
    @arena = Arena.new
  end

  def create
    if params["arena"] && params["arena"]["hero"]
      arena = Arena.new(arena_params)
      arena.user = current_user
      if arena.save
        current_user.add_arena_count

        redirect_to arenas_path, flash: {success: "Arena started successfully."}
      else
        render :new
      end
    else
      redirect_to new_arena_path, flash: {error: "Error: You must select a hero."}
    end
  end

  def edit
    @action = params[:action]
    @arena = Arena.find(params[:id])
  end

  def update
    @arena = Arena.find(params[:id])
    @arena.hero = params["arena"]["hero"]
    @arena.save
    redirect_to arenas_path, flash: {success: "Arena updated successfully."}
  end

  private

  def arena_params
    params.require(:arena).permit(:hero, :user)
  end

end
