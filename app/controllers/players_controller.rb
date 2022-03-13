class PlayersController < ApplicationController
  def index
  end

  def create
    if params[:player_details].nil?
      render json: { "created": 'fail', "reason": 'Blank JSON sent' },
             status: :unprocessable_entity
      return false
    end

    @player = Player.new(player_params)
    if @player.save
      render json: @player, status: :created, location: @player
    else
      render json: @player.errors, status: :unprocessable_entity
    end
  end

  private

  def player_params
    params.require(:player_details).permit(:first_name, :last_name, :dob, :nationality)
  end
end
