class StatsController < ApplicationController
  before_action :require_same_username, only: [:edit, :update]

  def show
    @user = User.find_by(username: params[:username].downcase)

    if @user
      @arena = Arena.current_arena(@user)
      if @arena
        @arena_score = @arena.score_formatted
      end
    end

  end

  def edit
    @stats = User.find_by(username: params[:username].downcase).stat
  end

  def update
    stat = Stat.find(params[:id])
    stat.update stat_params

    if stat.save
      redirect_to stat_path, flash: {success: "Your stat's were updated."}
    else
      render :edit
    end
  end

  private

  def stat_params
    params.require(:stat).permit(:wins, :losses, :winrate_when_first_wins, :winrate_when_first_losses,
      :winrate_when_second_wins, :winrate_when_second_losses, :total_series, :profitable_series,
      :nine0, :ninex, :xthree, :zerothree, :wr_as_druid_wins, :wr_as_druid_losses, :wr_as_hunter_wins,
      :wr_as_hunter_losses, :wr_as_mage_wins, :wr_as_mage_losses, :wr_as_paladin_wins, :wr_as_paladin_losses,
      :wr_as_priest_wins, :wr_as_priest_losses, :wr_as_shaman_wins, :wr_as_shaman_losses, :wr_as_rogue_wins,
      :wr_as_rogue_losses, :wr_as_warlock_wins, :wr_as_warlock_losses, :wr_as_warrior_wins, :wr_as_warrior_losses,
      :wr_against_druid_wins, :wr_against_druid_losses, :wr_against_hunter_wins, :wr_against_hunter_losses,
      :wr_against_mage_wins, :wr_against_mage_losses, :wr_against_paladin_wins, :wr_against_paladin_losses,
      :wr_against_priest_wins, :wr_against_priest_losses, :wr_against_shaman_wins, :wr_against_shaman_losses,
      :wr_against_rogue_wins, :wr_against_rogue_losses, :wr_against_warlock_wins, :wr_against_warlock_losses,
      :wr_against_warrior_wins, :wr_against_warrior_losses)
  end

  def require_same_username
    unless current_user && current_user.username == params[:username].downcase
      redirect_to root_path, flash: {error: "You are not authorized to perform that action."}
    end
  end

end
