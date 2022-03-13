class Player < ApplicationRecord

  def format_json_updates
    update('rating': '1200')
    update('matchesplayed': '0')
    update('rank': 'Unranked')
  end

end
