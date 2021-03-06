# frozen_string_literal: true

class Player < ApplicationRecord
  def format_json_updates
    update('points': '1200', 'matchesplayed': '0', 'rank': 'Unranked')
  end

  def player_format(globalrank = globalranking)
    { 'current position' => globalrank, 'full name' => "#{first_name} #{last_name}",
      'age' => ((Time.zone.now - dob.to_time) / 1.year.seconds).floor,
      'nationality' => nationality, 'rank name' => rank, 'points' => points }
  end

  def change_player_global_ranking(previous_global_rank, repeats_of_previous_rank, previous_player_score)
    array = find_new_ranking(previous_global_rank, repeats_of_previous_rank, previous_player_score)
    player_rank = array[0]
    repeats_of_previous_rank = array[1]
    update('globalranking': player_rank)
    recalculate_player_rank
    [player_rank, repeats_of_previous_rank, points.to_i]
  end

  def recalculate_player_rank
    unless matchesplayed.to_i < 3
      case points.to_i
      when (5000..9999)
        update('rank': 'Gold')
      when (3000..4999)
        update('rank': 'Silver')
      else
        update('rank': 'Bronze')
      end
      update('rank': 'Supersonic Legend') if points.to_i >= 10_000
    end
  end

  def update_points_after_match(win, loser_points = 0)
    if win == true
      update('points': (points.to_i + (loser_points * 0.1).floor).to_s,
             'matchesplayed': (matchesplayed.to_i + 1).to_s)
    else
      update('points': (points.to_i * 0.9).ceil.to_s, 'matchesplayed': (matchesplayed.to_i + 1).to_s)
    end
  end

  private

  def find_new_ranking(previous_global_rank, repeats_of_previous_rank, previous_player_score)
    first_player = previous_global_rank.zero?
    same_as_previous_player = (points.to_i == previous_player_score)
    last_ranking_repeated = !repeats_of_previous_rank.zero?
    player_rank = previous_global_rank

    player_rank += 1 if first_player || (!same_as_previous_player && !last_ranking_repeated)
    if !same_as_previous_player && last_ranking_repeated
      player_rank += repeats_of_previous_rank + 1
      repeats_of_previous_rank = 0
    end
    repeats_of_previous_rank += 1 if same_as_previous_player
    [player_rank, repeats_of_previous_rank]
  end
end
