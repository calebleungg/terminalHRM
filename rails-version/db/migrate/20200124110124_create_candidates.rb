class CreateCandidates < ActiveRecord::Migration[5.2]
  def change
    create_table :candidates do |t|
      t.string :first_name, limit: 50, null:false
      t.string :last_name, limit: 50, null:false
      t.numeric :job_id, null:false
      t.string :occupation, limit: 50, null:false
      t.string :email, limit: 50, null:false
      t.string :number, limit: 20, null:false
      t.string :address, limit: 200
      t.string :status, limit: 20, null:false

      t.timestamps
    end
  end
end
