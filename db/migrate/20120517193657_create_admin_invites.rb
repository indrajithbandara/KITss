class CreateAdminInvites < ActiveRecord::Migration
  def change
    create_table :admin_invites do |t|
      t.string :content
      t.integer :inviter_id

      t.timestamps
    end
  end
end
