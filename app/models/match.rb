# frozen_string_literal: true

class Match < ApplicationRecord
  def format_match(players)
    winner = Player.find(players[0].id)
    loser = Player.find(players[1].id)
    winner_full_name = "#{winner.first_name} #{winner.last_name}"
    loser_full_name = "#{loser.first_name} #{loser.last_name}"
    { 'match ID' => id, 'winner name' => winner_full_name, 'loser name' => loser_full_name,
      'winner rating' => winner.rating, 'winner rank' => winner.rank, 'winner global ranking' => winner.globalranking,
      'loser rating' => loser.rating, 'loser rank' => loser.rank, 'loser global ranking' => loser.globalranking, 'played at' => created_at }
  end

  def update_player_scores(players)
    winner = players[0]
    loser = players[1]
    winner.update_rating_after_match(true, loser.rating.to_i)
    loser.update_rating_after_match(false)
    PlayersController.recalculate_global_rankings
  end

  def find_players(winner_full_name, loser_full_name)
    winner = Player.find_by(first_name: winner_full_name[0].capitalize, last_name: winner_full_name[1].capitalize)
    loser = Player.find_by(first_name: loser_full_name[0].capitalize, last_name: loser_full_name[1].capitalize)
    players = [winner, loser]
  end
end
