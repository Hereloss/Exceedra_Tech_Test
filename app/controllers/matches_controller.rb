class MatchesController < ApplicationController

  def create
    if params[:match_details].blank? || params[:match_details]['winner_name'].blank? || params[:match_details]['loser_name'].blank?
      render json: { "created": 'fail', "reason": 'Blank or Incomplete JSON sent' },
             status: :unprocessable_entity
      return false
    end
  end
end
