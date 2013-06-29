require 'spec_helper'

describe "bookmarks/edit" do
  before(:each) do
    @bookmark = assign(:bookmark, stub_model(Bookmark,
      :name => "MyString",
      :page => "",
      :sura => "",
      :aya => ""
    ))
  end

  it "renders the edit bookmark form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", bookmark_path(@bookmark), "post" do
      assert_select "input#bookmark_name[name=?]", "bookmark[name]"
      assert_select "input#bookmark_page[name=?]", "bookmark[page]"
      assert_select "input#bookmark_sura[name=?]", "bookmark[sura]"
      assert_select "input#bookmark_aya[name=?]", "bookmark[aya]"
    end
  end
end
