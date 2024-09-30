class CreateAssertions < ActiveRecord::Migration[7.1]
  def change
    create_table :assertions do |t|
      t.string :url, null: false
      t.string :text, null: false
      t.integer :status, null: false, default: 0
      t.integer :num_links, null: false, default: 0
      t.integer :num_images, null: false, default: 0

      t.timestamps
    end
  end
end
