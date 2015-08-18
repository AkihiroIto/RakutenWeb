class CreateRakutens < ActiveRecord::Migration
  def change
    create_table :rakutens do |t|

      t.timestamps null: false
    end
  end
end
