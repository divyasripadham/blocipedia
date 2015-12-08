class CreateAmounts < ActiveRecord::Migration
  def change
    create_table :amounts do |t|
      t.integer :value

      t.timestamps null: false
    end
  end
end
