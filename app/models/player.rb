class Player < ApplicationRecord

  def format_json_updates
    update('rating': '1200')
    update('matchesplayed': '0')
    update('rank': 'Unranked')
  end

  def player_format(globalrank = globalranking)
    current_hash = {}
    current_hash['current position'] = globalrank
    current_hash['full name'] = "#{first_name} #{last_name}"
    current_hash['age'] = ((Time.zone.now - dob.to_time) / 1.year.seconds).floor
    current_hash['nationality'] = nationality
    current_hash['rank name'] = rank
    current_hash['points'] = rating
    current_hash
  end

  def change_player_global_ranking(previous_global_rank, repeats_of_previous_rank, previous_player_score)
    first_player = (previous_global_rank.zero?)
    same_as_previous_player = (rating.to_i == previous_player_score)
    last_ranking_repeated = (!repeats_of_previous_rank.zero?)
    player_rank = previous_global_rank

    player_rank += 1 if first_player || ((!same_as_previous_player) && !last_ranking_repeated)
    if (!same_as_previous_player) && (last_ranking_repeated)
      player_rank +=  repeats_of_previous_rank + 1
      repeats_of_previous_rank = 0
    end
    repeats_of_previous_rank += 1 if same_as_previous_player
    update('globalranking': player_rank)
    [player_rank, repeats_of_previous_rank, rating.to_i]
  end

  def recalculate_player_rank
    unless matchesplayed.to_i < 3
      case rating.to_i
      when (5000..9999)
        update('rank': 'Gold')
      when (3000..4999)
        update('rank': 'Silver')
      else
        update('rank': 'Bronze')
      end
      update('rank': 'Supersonic Legend') if rating.to_i >= 10000
    end
  end

end
