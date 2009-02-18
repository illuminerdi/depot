class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :name
      t.string :hashed_password
      t.string :salt

      t.timestamps
    end
    
    User.create(:name => "test", :password => "foo", :password_confirmation => "foo") if RAILS_ENV != 'production'
  end

  def self.down
    drop_table :users
  end
end
