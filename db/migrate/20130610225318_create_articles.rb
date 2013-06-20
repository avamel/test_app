class CreateArticles < ActiveRecord::Migration
  def change
    create_table :articles do |t|
      t.string :title
      t.text :content
      t.date :published_on
      t.integer :author_id

      t.timestamps
    end
   add_index :articles, [:published_on, :created_at ]
  end
end
