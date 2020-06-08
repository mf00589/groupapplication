class AddStudentEmail < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :student_email, :string

  end
end
