class CreateInterventions < ActiveRecord::Migration[5.2]
  def change
    create_table :interventions do |t|
      t.integer :employee_id
      t.integer :building_id
      t.integer :battery_id
      t.integer :column_id
      t.integer :elevator_id
      t.string :start_interv
      t.string :stop_interv
      t.string :result
      t.string :reports
      t.string :status

      t.timestamps
    end
  end
end
