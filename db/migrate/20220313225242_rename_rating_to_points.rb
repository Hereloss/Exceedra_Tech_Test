# frozen_string_literal: true

class RenameRatingToPoints < ActiveRecord::Migration[7.0]
  def change
    rename_column :players, :rating, :points
  end
end
