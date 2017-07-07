class CreateSells < ActiveRecord::Migration[5.0]
  def change
    create_table :sells do |t|
      t.integer :price, default: 0
      t.integer :amount, default: 1
      t.references :item, index: true
      t.timestamps
    end
  end
end
