class Match < ApplicationRecord

  def update_player_scores(winner, loser)
    winner.update_rating_after_match(true, loser.rating.to_i)
    loser.update_rating_after_match(false)
    PlayersController.recalculate_global_rankings
  end

end
