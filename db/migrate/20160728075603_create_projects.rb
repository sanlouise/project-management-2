class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :title
      t.string :details
      t.date :deadline
      t.belongs_to :tenant, index: true

      t.timestamps
    end
  end
end
