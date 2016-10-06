class CreateTasks < ActiveRecord::Migration[5.0]
  def up
    create_table :tasks do |t|

      t.timestamps

      t.string 'user_url'
      t.string 'task_type'
      t.string 'owner_url'
      t.string 'task_state'
      t.string 'target_url'
      t.string 'continue_url'
      t.string 'cancel_url'
      t.integer 'active'
    end
  end

  def down
    drop_table :tasks
  end
end
