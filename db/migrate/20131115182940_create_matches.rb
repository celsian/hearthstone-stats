class CreateMatches < ActiveRecord::Migration
  def change
    create_table :matches do |t|
      t.references :arena, index: true
      t.boolean :win
      t.string :enemy
      t.boolean :first

      t.timestamps
    end
  end
end
