class PlayersController < ApplicationController
  def index
  end

  def create
    if params[:player_details].nil?
      render json: { "created": 'fail', "reason": 'Blank JSON sent' },
             status: :unprocessable_entity
      return false
    end
    if incomplete_information == true
      reason = 'Missing or incorrect sign up information;'
      render json: { "created": 'fail', "reason": reason }, status: :unprocessable_entity
      return false
    end

    @player = Player.new(player_params)
    if @player.save
      render json: @player, status: :created, location: @player
    else
      render json: @player.errors, status: :unprocessable_entity
    end
  end

  def incomplete_information
    if params[:player_details]['first_name'].blank? || params[:player_details]['last_name'].blank? ||
       params[:player_details]['nationality'].blank? || params[:player_details]['dob'].blank?
      return true
    end

    parseable = begin
      Date.strptime(params[:player_details]['dob'], '%d-%m-%Y')
    rescue StandardError
      true
    end
  end

  private

  def player_params
    params.require(:player_details).permit(:first_name, :last_name, :dob, :nationality)
  end
end
