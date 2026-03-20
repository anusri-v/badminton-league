class Player < ApplicationRecord
  validates_format_of :email, with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
  validates_format_of :phone, with: /\A[0-9]{10}\z/

  def win_count
    Match.where(winner_id: id).count
  end

  def loss_count
    Match.where('(player_1_id = ? OR player_2_id = ?) AND winner_id != ? AND winner_id IS NOT NULL', id, id, id).count
  end
end
