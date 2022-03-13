class Player < ApplicationRecord

  def format_json_updates
    update('rating': '1200')
    update('matchesplayed': '0')
    update('rank': 'Unranked')
  end

  def player_format
    current_hash = {}
    current_hash['current position'] = globalranking
    current_hash['full name'] = "#{first_name} #{last_name}"
    current_hash['age'] = ((Time.zone.now - dob.to_time) / 1.year.seconds).floor
    current_hash['nationality'] = nationality
    current_hash['rank name'] = rank
    current_hash['points'] = rating
    current_hash
  end

end
