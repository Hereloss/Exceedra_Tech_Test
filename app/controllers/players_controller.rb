# frozen_string_literal: true

class PlayersController < ApplicationController
  def index
    search_players_database
    set_type_and_order_found_players
    render json: format, status: :found
  end

  def create
    return false if blank_json == true
    return false if able_to_sign_up == false

    make_params_capital
    @player = Player.new(player_params)

    if @player.save
      save_player
    else
      render json: @player.errors, status: :unprocessable_entity
    end
  end

  def self.recalculate_global_rankings(player = nil)
    previous_global_rank = 0
    repeats_of_previous_rank = 0
    previous_player_score = 0

    Player.all.order('rating DESC').each do |player_row|
      array = player_row.change_player_global_ranking(previous_global_rank, repeats_of_previous_rank,
                                                      previous_player_score)
      previous_global_rank = array[0]
      repeats_of_previous_rank = array[1]
      previous_player_score = array[2]
      @player_start_position = previous_global_rank if player == player_row
    end
    @player_start_position
  end

  private

  def search_players_database
    unless params[:search_type].blank?
      case params[:search_type].downcase
      when 'nationality'
        return @players = Player.where('nationality == ?', params[:nationality].capitalize)
      when 'rank'
        return @players = Player.where('rank == ?', params[:rank].capitalize)
      end
    end
    @players = Player.all
    @type = 'all'
  end

  def set_type_and_order_found_players
    @type = params[:search_type] if params[:search_type] == ('nationality' || 'rank')
    PlayersController.recalculate_global_rankings
    @players = @players.order(Arel.sql("`rank` != 'Unranked' desc, rating DESC"))
  end

  def format
    formatted_array = []
    @players.each do |player|
      formatted_array << player.player_format
    end
    formatted_array
  end

  def blank_json
    if params[:player_details].nil?
      render json: { "created": 'fail', "reason": 'Blank JSON sent' },
             status: :unprocessable_entity
      true
    end
  end

  def able_to_sign_up
    reason = ''
    if incomplete_information == true
      render json: { "created": 'fail', "reason": 'Missing or incorrect sign up information;' },
             status: :unprocessable_entity
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

  def blank_details_in_json
    if params[:player_details]['first_name'].blank? || params[:player_details]['last_name'].blank? ||
       params[:player_details]['nationality'].blank? || params[:player_details]['dob'].blank?
      true
    end
  end

  def make_params_capital
    params[:player_details]['first_name'].capitalize!
    params[:player_details]['last_name'].capitalize!
    params[:player_details]['nationality'].capitalize!
  end

  def save_player
    @player.format_json_updates
    player_start_position = PlayersController.recalculate_global_rankings(@player)
    render json: @player.player_format(player_start_position), status: :created, location: @player
  end

  def player_params
    params.require(:player_details).permit(:first_name, :last_name, :dob, :nationality)
  end
end
