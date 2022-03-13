class CreatePlayers < ActiveRecord::Migration[7.0]
  def change
    create_table :players do |t|
      t.string :first_name
      t.string :last_name
      t.string :nationality
      t.string :dob
      t.integer :rating
      t.integer :globalranking
      t.integer :matchesplayed

      t.timestamps
    end
  end
end
