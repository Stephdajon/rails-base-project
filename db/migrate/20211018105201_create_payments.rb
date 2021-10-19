class CreatePayments < ActiveRecord::Migration[6.0]
  def change
    create_table :payments do |t|
      t.string :name
      t.text :details
      t.decimal :price, default: 0.00, scale: 2, precision: 8
      t.integer :status, default: 0
      t.string :reference_number
      t.integer :user_id
      t.integer :lesson_id
      t.timestamps
    end
  end
end
