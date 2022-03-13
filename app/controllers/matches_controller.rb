class MatchesController < ApplicationController

  def create
    return false if valid_match == false

    @match = Match.new(match_params)

    if @match.save
      @winner = Player.find_by(first_name: params[:match_details]['winner_name'].split(" ")[0], last_name: params[:match_details]['winner_name'].split(" ")[1])
      @loser = Player.find_by(first_name: params[:match_details]['loser_name'].split(" ")[0], last_name: params[:match_details]['loser_name'].split(" ")[1])
      @match.update_player_scores(@winner,@loser)
      render json: @match, status: :created, location: @match
    else
      render json: @match.errors, status: :unprocessable_entity
    end
  end 

  private
  
  def valid_match
    if params[:match_details].blank? || params[:match_details]['winner_name'].blank? || params[:match_details]['loser_name'].blank?
      render json: { "created": 'fail', "reason": 'Blank or Incomplete JSON sent' },
             status: :unprocessable_entity
      return false
    end

    winner_registered = user_is_registered(params[:match_details]['winner_name'])
    loser_registered = user_is_registered(params[:match_details]['loser_name'])

    unless winner_registered && loser_registered
        render json: { "created": 'fail', "reason": 'One or both players are not registered' },
        status: :unprocessable_entity
        false
    end

  end

  def user_is_registered(full_name)
    !Player.where('first_name = ? and last_name = ?', full_name.split(' ')[0],full_name.split(' ')[1]).empty?
  end


  def match_params
    params.require(:match_details).permit(:winner_id, :loser_id, :winner_name, :loser_name)
  end
end
