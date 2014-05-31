class CombineTagNamesAndTags < ActiveRecord::Migration
  def up
    # add fields to tags
    add_column :tags, :name, :string
    add_column :tags, :user_id, :integer

    # migrate data
    TagName.includes(:tags).each do |tag_name|
      tag_name.tags.each do |tag|
        tag.name = tag_name.name
        tag.user = tag_name.user
        tag.save
      end
    end

    # remove tagnames
    remove_column :tags, :tag_name_id
    drop_table :tag_names
  end

  def down
    # create tagnames
    create_table :tag_names do |t|
      t.references :user
      t.string :name

      t.timestamps
    end
    add_column :tags, :tag_name_id, :integer

    # migrate data back
    Tag.all.each do |tag|
      tag_name = TagName.where(name: tag.name, user_id: tag.user.id).first_or_create
      tag.tag_name_id = tag_name.id
      tag.save
    end

    # remove fields from tags
    remove_column :tags, :name
    remove_column :tags, :user_id
  end
end
