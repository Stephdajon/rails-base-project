class CreateTransactions < ActiveRecord::Migration[6.0]
  def change
    create_table :transactions do |t|
      t.string :name
      t.text :details
      t.decimal :price, default: 0.00, scale: 2, precision: 8
      t.text :reference_number
      t.integer :user_id
      t.integer :lesson_id
      t.integer :status, default: 0
      t.timestamps
    end
  end
end
