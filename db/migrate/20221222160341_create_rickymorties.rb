class CreateRickymorties < ActiveRecord::Migration[6.0]
  def change
    create_table :rickymorties do |t|

      t.timestamps
    end
  end
end
