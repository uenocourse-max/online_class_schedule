class CreateUsers < ActiveRecord::Migration[8.1]
  def change
    create_table :users do |table|
      table.string :email, null: false
      table.string :password_digest, null: false
      table.string :role, null: false
      table.timestamps
    end

    add_index :users, "lower(email)", unique: true, name: "index_users_on_lower_email"
    add_check_constraint :users, "role IN ('admin', 'teacher', 'student')", name: "users_role_valid"
  end
end
