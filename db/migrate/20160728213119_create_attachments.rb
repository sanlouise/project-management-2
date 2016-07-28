class CreateAttachments < ActiveRecord::Migration
  def change
    create_table :attachments do |t|
      t.string :name
      t.string :key
      t.belongs_to :project, index: true

      t.timestamps
    end
  end
end
