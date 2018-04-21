class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.date :birthday
      t.text :intro
      t.string :avatar
      t.string :role

      t.timestamps
    end
  end
end
