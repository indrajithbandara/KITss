class FixLinkedInForUsers < ActiveRecord::Migration
  def change
    add_column :users, :linkedin_id, :string
    remove_column :users, :linkedin_secret
    remove_column :users, :linkedin_token
  end
end
