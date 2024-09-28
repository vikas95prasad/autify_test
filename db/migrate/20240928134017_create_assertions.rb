class CreateAssertions < ActiveRecord::Migration[7.1]
  def change
    create_table :assertions do |t|
      t.string :url
      t.string :text
      t.string :status
      t.integer :num_links
      t.integer :num_images

      t.timestamps
    end
  end
end
