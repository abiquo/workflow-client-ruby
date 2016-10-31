class AddUuidToTasks < ActiveRecord::Migration[5.0]
  def up
    add_column :tasks, :uuid, :string
  end

  def down
    drop_column :tasks, :uuid
  end
end
