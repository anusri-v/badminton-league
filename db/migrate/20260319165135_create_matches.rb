class CreateMatches < ActiveRecord::Migration[7.1]
  def change
    create_table :matches do |t|
      t.bigint :player_1_id
      t.bigint :player_2_id
      t.bigint :winner_id
      t.datetime :scheduled_on

      t.timestamps
    end

    add_foreign_key :matches, :players, column: :player_1_id
    add_foreign_key :matches, :players, column: :player_2_id
  end
end
