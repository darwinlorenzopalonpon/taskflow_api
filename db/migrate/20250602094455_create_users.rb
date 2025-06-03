class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users do |t|
      t.string :email, null: false
      t.string :name, null: false
      t.string :avatar_url
      t.string :provider
      t.string :uid

      t.timestamps
    end

    add_index :users, :email, unique: true
    add_index :users, [ :provider, :uid ], unique: true
  end
end
