class CreateInterviews < ActiveRecord::Migration[5.2]
  def change
    create_table :interviews do |t|
      t.datetime :date
      t.integer :candidate_id
      t.integer :job_id
      t.string :interviewer, limit: 200
      t.string :status, limit: 50
      t.string :comments

      t.timestamps
    end
  end
end
