class CreateUserCarts < ActiveRecord::Migration[6.0]
  def change
    create_table :user_carts do |t|
      t.integer :user_id
      t.integer :lesson_id
      t.integer :status, default: 0
      t.timestamps
    end
  end
end
