class CreateExpenses < ActiveRecord::Migration[7.1]
  def change
    create_table :expenses do |t|
      t.decimal :amount, default: 0.0
      t.text :description
      t.datetime :timestamp
      t.integer :group, default: 1
      t.references :message, null: false, foreign_key: true

      t.timestamps
    end
  end
end
