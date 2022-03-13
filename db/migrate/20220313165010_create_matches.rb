class CreateMatches < ActiveRecord::Migration[7.0]
  def change
    create_table :matches do |t|
      t.integer :winner_id
      t.string :winner_name
      t.integer :loser_id
      t.string :loser_name
      t.string :string

      t.timestamps
    end
  end
end
