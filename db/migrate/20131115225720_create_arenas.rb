class CreateArenas < ActiveRecord::Migration
  def change
    create_table :arenas do |t|
      t.string :hero
      t.boolean :complete
      t.references :user, index: true

      t.timestamps
    end
  end
end
