class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.string :email
      t.string :token
      t.belongs_to :tenant, index: true

      t.timestamps
    end
  end
end
