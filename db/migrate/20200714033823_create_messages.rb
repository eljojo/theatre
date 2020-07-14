class CreateMessages < ActiveRecord::Migration[6.0]
  def change
    create_table :messages do |t|
      t.integer :actor_id, null: false
      t.boolean :processed, default: false
      t.string :action
      t.text :params
      t.text :new_state

      t.timestamps
    end

    add_index :messages, :actor_id
    add_index :messages, :processed
  end
end
