class CreateActors < ActiveRecord::Migration[6.0]
  def change
    create_table :actors do |t|
      t.string :kind, null: false
      t.integer :parent_id
      t.text :state

      t.timestamps
    end

    add_index :actors, :kind
    add_index :actors, :parent_id
  end
end
