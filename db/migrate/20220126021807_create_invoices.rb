class CreateInvoices < ActiveRecord::Migration[7.0]
  def change
    create_table :invoices do |t|
      t.date :date
      t.boolean :received
      t.decimal :value, precision: 8, scale: 2

      t.timestamps
    end
  end
end
