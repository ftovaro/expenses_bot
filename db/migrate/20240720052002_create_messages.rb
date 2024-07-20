class CreateMessages < ActiveRecord::Migration[7.1]
  def change
    create_table :messages do |t|
      t.string :sender_name
      t.string :sender_phone
      t.text :message_body
      t.datetime :timestamp
      t.boolean :soft_deleted, default: false

      t.timestamps
    end
  end
end
