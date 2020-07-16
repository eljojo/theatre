class AddSenderIdToMessages < ActiveRecord::Migration[6.0]
  def change
    add_column :messages, :sender_id, :integer
    rename_column :messages, :actor_id, :receiver_id
  end
end
