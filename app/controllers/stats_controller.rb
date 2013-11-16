class StatsController < ApplicationController
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
end
