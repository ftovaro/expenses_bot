class ChangeAmountToIntegerInExpenses < ActiveRecord::Migration[6.0]
  def up
    change_column :expenses, :amount, :integer, using: 'amount::integer'
  end

  def down
    change_column :expenses, :amount, :decimal, default: 0.0, precision: 10, scale: 2
  end
end
