class CreateEnrolledLessons < ActiveRecord::Migration[6.0]
  def change
    create_table :enrolled_lessons do |t|
      t.string :title
      t.text :description
      t.decimal :price, default: 0.00, scale: 2, precision: 8
      t.integer :user_id
      t.integer :lesson_id
      t.string :status, default: 'paid'
      t.timestamps
    end
  end
end
