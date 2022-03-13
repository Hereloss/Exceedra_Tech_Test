# frozen_string_literal: true

class RemoveStringFromMatches < ActiveRecord::Migration[7.0]
  def change
    remove_column :matches, :string, :string
  end
end
