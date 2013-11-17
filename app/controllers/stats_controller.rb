class StatsController < ApplicationController
  before_action :require_same_username, only: [:edit, :update]

  def show
    @user = User.find_by(username: params[:username].downcase)

    if @user
      @arena = Arena.current_arena(@user)

      if @arena
        @arena_score = @arena.score_formatted
      end

      @overall = @user.total_wins
      @overall_winrate = @user.winrate

      @winrate_turn = @user.winrate_turn
      @series_stats = @user.series_stats
      @as_class = @user.winrate_as_class
      @against_class = @user.winrate_against_class
    end
  end

  def edit
    @stats = User.find_by(username: params[:username].downcase).stat
  end

  def update

  end

  private

  def require_same_username
    unless current_user && current_user.username == params[:username].downcase
      redirect_to root_path, flash: {error: "You are not authorized to perform that action."}
    end
  end

end
