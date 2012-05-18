class UpdateAdminInvites < ActiveRecord::Migration
  def up
    rename_column :admin_invites, :content, :token
    add_column :admin_invites, :email, :string
  end

  def down
    rename_column :admin_invites, :content, :token
    remove_column :admin_invites, :email
  end
end
