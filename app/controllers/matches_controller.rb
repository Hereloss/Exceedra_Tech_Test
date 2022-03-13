class MatchesController < ApplicationController

  def create
    return false if valid_match == false

    @match = Match.new(match_params)

    if @match.save
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

    @winner_full_name = params[:match_details]['winner_name'].split(' ')
    @loser_full_name = params[:match_details]['loser_name'].split(' ')

    if (Player.where('first_name = ? and last_name = ?', @winner_full_name[0],
        @winner_full_name[1]).empty? == true) || (Player.where('first_name = ? and last_name = ?', @loser_full_name[0],
                                                           @loser_full_name[1]).empty? == true)
        render json: { "created": 'fail', "reason": 'One or both players are not registered' },
        status: :unprocessable_entity
        false
    end

  end


  def match_params
    params.require(:match_details).permit(:winner_id, :loser_id, :winner_name, :loser_name)
  end
end
