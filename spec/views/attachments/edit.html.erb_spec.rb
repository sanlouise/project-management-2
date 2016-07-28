require 'rails_helper'

RSpec.describe "attachments/edit", type: :view do
  before(:each) do
    @attachment = assign(:attachment, Attachment.create!(
      :name => "MyString",
      :key => "MyString",
      :project => nil
    ))
  end

  it "renders the edit attachment form" do
    render

    assert_select "form[action=?][method=?]", attachment_path(@attachment), "post" do

      assert_select "input#attachment_name[name=?]", "attachment[name]"

      assert_select "input#attachment_key[name=?]", "attachment[key]"

      assert_select "input#attachment_project_id[name=?]", "attachment[project_id]"
    end
  end
end
