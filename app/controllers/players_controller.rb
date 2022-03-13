class PlayersController < ApplicationController
  def index
  end

  def create
    if params[:user_details].nil?
      render json: { "created": 'fail', "reason": 'Blank JSON sent' },
             status: :unprocessable_entity
      return false
    end
  end

  private

  def user_params
    params.require(:user_details).permit(:first_name, :last_name, :dob, :nationality)
  end
end
