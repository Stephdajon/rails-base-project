class AddUsernameFirstnameLastnameToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :username, :string
    add_column :users, :status, :string, default: 'pending'
    add_index :users, :username, unique: true
    add_column :users, :firstname, :string
    add_column :users, :lastname, :string
  end
end
