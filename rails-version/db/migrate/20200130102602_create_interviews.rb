class CreateInterviews < ActiveRecord::Migration[5.2]
  def change
    create_table :interviews do |t|
      t.datetime :date, null:false
      t.integer :candidate_id, null:false
      t.integer :job_id, null:false
      t.string :interviewer, limit: 200, null:false
      t.string :status, limit: 50, null:false
      t.string :comments, null:false

      t.timestamps
    end
  end
end
