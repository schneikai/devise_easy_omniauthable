class Create<%= class_name %> < ActiveRecord::Migration
  def change
    create_table(:<%= table_name %>) do |t|
      t.integer :authenticatable_id
      t.string :authenticatable_type
      t.string :provider
      t.string :uid
      t.string :token
      t.string :token_secret

      t.timestamps
    end
  end
end
