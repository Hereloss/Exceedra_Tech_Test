class PlayersController < ApplicationController
  def index
    case params[:search_type]
    when 'points'
      @players = Player.where('rating > ?', params[:points])
    when 'nationality'
      @players = Player.where('nationality == ?', params[:nationality])
    when 'rank'
      @players = Player.where('rank == ?', params[:rank])
    else
      @players = Player.all
      @type = 'all'
    end
    @type = params[:search_type] if params[:search_type] == ('nationality' || 'points' || 'rank')
    @players.order(Arel.sql("`rank` != 'Unranked' desc, rating DESC"))
    render json: format, status: :found
  end

  def create
    return false if blank_json == false
    return false if unable_to_sign_up == false

    @player = Player.new(player_params)
    save_player
  end

  private

  def format
    formatted_array = []
    @players.each do |player|
      formatted_array << player.player_format
    end
    formatted_array
  end

  def unable_to_sign_up
    reason = ""
    if incomplete_information == true
      render json: { "created": 'fail', "reason": "Missing or incorrect sign up information;" }, status: :unprocessable_entity
      return false
    end
    reason += 'Name is already taken;' if Player.where('first_name = ? and last_name = ?', params[:player_details]['first_name'],
                                                                           params[:player_details]['last_name']).empty? == false
    reason += 'Under age limit;' if (2022 - (params[:player_details]['dob'].split('-')[2]).to_i) < 16
    unless reason == ""
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
      @player.format_json_updates
      render json: @player.player_format, status: :created, location: @player
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
