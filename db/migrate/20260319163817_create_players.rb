class CreatePlayers < ActiveRecord::Migration[7.1]
  def change
    create_table :players do |t|
      t.string :name
      t.string :email
      t.string :phone
      t.string :gender

      t.timestamps
    end
  end
end
