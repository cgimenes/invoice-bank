class CreatePayments < ActiveRecord::Migration[7.0]
  def change
    create_table :payments do |t|
      t.decimal :value, precision: 8, scale: 2
      t.date :date
      t.references :company, null: false, foreign_key: true

      t.timestamps
    end
  end
end
