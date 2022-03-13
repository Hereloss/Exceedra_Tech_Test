class Match < ApplicationRecord

  def format_match(winnerid, loserid)
    winner = Player.find(winnerid)
    loser = Player.find(loserid)
    winner_full_name = "#{winner.first_name} #{winner.last_name}"
    loser_full_name = "#{loser.first_name} #{loser.last_name}"
    { 'match ID' => id, 'winner name' => winner_full_name, 'loser name' => loser_full_name,
      'winner rating' => winner.rating, 'winner rank' => winner.rank, 'winner global ranking' => winner.globalranking,
      'loser rating' => loser.rating, 'loser rank' => loser.rank, 'loser global ranking' => loser.globalranking, 'played at' => created_at }
  end

  def update_player_scores(winner, loser)
    winner.update_rating_after_match(true, loser.rating.to_i)
    loser.update_rating_after_match(false)
    PlayersController.recalculate_global_rankings
  end

end
