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

  def change_player_global_ranking(i, j, previous_player_score)
    i += 1 if i.zero? || ((rating.to_i != previous_player_score) && j.zero?)
    if (rating.to_i != previous_player_score) && (j != 0)
      i = i + j + 1
      j = 0
    end
    j += 1 if rating.to_i == previous_player_score
    update('globalranking': i)
    [i, j, rating.to_i]
  end

end
