class AddInfoToUsers < ActiveRecord::Migration
  def change
    add_column :users, :headline, :string
    add_column :users, :university_headline, :string
  end
end
