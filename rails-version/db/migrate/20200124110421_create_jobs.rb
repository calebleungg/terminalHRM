class CreateJobs < ActiveRecord::Migration[5.2]
  def change
    create_table :jobs do |t|
      t.string :title, limit: 50, null:false
      t.string :work_type, limit: 50, null:false
      t.decimal :salary, precision: 10, scale: 2, null:false
      t.numeric :openings, null:false
      t.date :start_date, null:false
      t.string :reporting_to, limit: 50, null:false

      t.timestamps
    end
  end
end
