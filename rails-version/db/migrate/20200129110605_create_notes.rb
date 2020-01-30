class CreateNotes < ActiveRecord::Migration[5.2]
  def change
    create_table :notes do |t|
      t.numeric :candidate_id
      t.string :note, limit: 500

      t.timestamps
    end
  end
end
