ActiveRecord::Schema.define(:version => 1) do

  create_table :crypted_password_users do |t|
    t.string :username
    t.string :email
    t.string :password_crypt, :limit => 40
    t.string :password_salt,  :limit => 40
    t.string :remember_token
    t.string :role
    t.datetime :created_at
    t.datetime :updated_at
  end  

  create_table :plain_text_password_users do |t|
    t.string :username
    t.string :email
    t.string :password
    t.string :remember_token
    t.string :email_validation_key
    t.datetime :created_at
    t.datetime :updated_at
  end  

  create_table :users do |t|
    t.string :username
    t.string :email
    t.string :password_crypt, :limit => 40
    t.string :password_salt,  :limit => 40
    t.string :remember_token
    t.datetime :created_at
    t.datetime :updated_at
  end  

end