class CreateFactInterventions < ActiveRecord::Migration[5.2]
  def change
    create_table :fact_interventions do |t|
      t.integer :employee_id, :null => false
      t.integer :building_id, :null => false
      t.integer :battery_id
      t.integer :column_id
      t.integer :elevator_id
      t.datetime :start_interv, :null => false
      t.datetime :stop_interv
      t.string :result, :null => false, :default => ''
      t.string :reports
      t.string :status, :null => false, :default => ''

      t.timestamps
    end
  end
end
