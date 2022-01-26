class CreateTransfers < ActiveRecord::Migration[7.0]
  def change
    create_table :transfers do |t|
      t.decimal :value, precision: 8, scale: 2
      t.date :date

      t.timestamps
    end
  end
end
