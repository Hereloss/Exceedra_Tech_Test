class MatchesController < ApplicationController

  def create
    return false if valid_match == false

    @match = Match.new(match_params)

    if @match.save
      save_match
    else
      render json: @match.errors, status: :unprocessable_entity
    end
  end 

  private
  
  def valid_match
    return false if blank_json == false

    return false if players_registered == false
  end

  def blank_json
    if params[:match_details].blank? || params[:match_details]['winner_name'].blank? || params[:match_details]['loser_name'].blank?
      render json: { "created": 'fail', "reason": 'Blank or Incomplete JSON sent' },
             status: :unprocessable_entity
      return false
    end
  end

  def players_registered
    winner_registered = user_is_registered(params[:match_details]['winner_name'])
    loser_registered = user_is_registered(params[:match_details]['loser_name'])

    unless winner_registered && loser_registered
        render json: { "created": 'fail', "reason": 'One or both players are not registered' },
        status: :unprocessable_entity
        return false
    end
    if (players_match_ids(params[:match_details]['winner_name'], true) && players_match_ids(params[:match_details]['loser_name'], false)) == false
      render json: { "created": 'fail', "reason": 'IDs dont match players' },
        status: :unprocessable_entity
      return false
    end
  end

  def user_is_registered(full_name)
    !Player.where('first_name = ? and last_name = ?', full_name.split(' ')[0].capitalize,full_name.split(' ')[1].capitalize).empty?
  end

  def players_match_ids(full_name, win)
    if win == true 
      Player.where('first_name = ? and last_name = ?', full_name.split(' ')[0].capitalize,full_name.split(' ')[1].capitalize)[0].id == params[:match_details]['winner_id'].to_i
    else
      Player.where('first_name = ? and last_name = ?', full_name.split(' ')[0].capitalize,full_name.split(' ')[1].capitalize)[0].id == params[:match_details]['loser_id'].to_i 
    end
  end

  def save_match
      find_players
      @match.update_player_scores(@winner,@loser)
      render json: @match.format_match(@winner.id, @loser.id), status: :created, location: @match
  end

  def find_players
    winner_full_name = params[:match_details]['winner_name'].split(" ")
    loser_full_name = params[:match_details]['loser_name'].split(" ")
    @winner = Player.find_by(first_name: winner_full_name[0].capitalize, last_name: winner_full_name[1].capitalize)
    @loser = Player.find_by(first_name: loser_full_name[0].capitalize, last_name: loser_full_name[1].capitalize)
  end

  def match_params
    params.require(:match_details).permit(:winner_id, :loser_id, :winner_name, :loser_name)
  end
end
