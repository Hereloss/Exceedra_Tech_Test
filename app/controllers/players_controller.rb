class PlayersController < ApplicationController
  def index
  end

  def create
    return false if blank_json == false
    return false if unable_to_sign_up == false

    @player = Player.new(player_params)
    save_player
  end

  private

  def unable_to_sign_up
    reason = ""
    if incomplete_information == true
      reason += 'Missing or incorrect sign up information;'
      render json: { "created": 'fail', "reason": reason }, status: :unprocessable_entity
      return false
    end
    reason += 'Name is already taken;' if Player.where('first_name = ? and last_name = ?', params[:player_details]['first_name'],
                                                                           params[:player_details]['last_name']).empty? == false
    reason += 'Under age limit;' if (2022 - (params[:player_details]['dob'].split('-')[2]).to_i) < 16
    unless reason == ''
      render json: { "created": 'fail', "reason": reason }, status: :unprocessable_entity
      false
    end
  end

  def incomplete_information
    return true if blank_details_in_json == true

    parseable = begin
      Date.strptime(params[:player_details]['dob'], '%d-%m-%Y')
    rescue StandardError
      true
    end
  end

  def save_player
    if @player.save
      render json: @player, status: :created, location: @player
    else
      render json: @player.errors, status: :unprocessable_entity
    end
  end

  def blank_json
    if params[:player_details].nil?
      render json: { "created": 'fail', "reason": 'Blank JSON sent' },
             status: :unprocessable_entity
      return false
    end
  end

  def blank_details_in_json
    if params[:player_details]['first_name'].blank? || params[:player_details]['last_name'].blank? ||
      params[:player_details]['nationality'].blank? || params[:player_details]['dob'].blank?
     return true
   end
  end

  def player_params
    params.require(:player_details).permit(:first_name, :last_name, :dob, :nationality)
  end
end
