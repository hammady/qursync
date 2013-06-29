require 'spec_helper'

describe "bookmarks/new" do
  before(:each) do
    assign(:bookmark, stub_model(Bookmark,
      :name => "MyString",
      :page => "",
      :sura => "",
      :aya => ""
    ).as_new_record)
  end

  it "renders new bookmark form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", bookmarks_path, "post" do
      assert_select "input#bookmark_name[name=?]", "bookmark[name]"
      assert_select "input#bookmark_page[name=?]", "bookmark[page]"
      assert_select "input#bookmark_sura[name=?]", "bookmark[sura]"
      assert_select "input#bookmark_aya[name=?]", "bookmark[aya]"
    end
  end
end
