class ImproveIndexesInMessages < ActiveRecord::Migration[6.0]
  def change
    remove_index :messages, :processed
    remove_index :messages, :receiver_id
    add_index :messages, [:receiver_id, :processed]
  end
end
