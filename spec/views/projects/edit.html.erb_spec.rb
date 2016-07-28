require 'rails_helper'

RSpec.describe "projects/edit", type: :view do
  before(:each) do
    @project = assign(:project, Project.create!(
      :title => "MyString",
      :details => "MyString",
      :tenant => nil
    ))
  end

  it "renders the edit project form" do
    render

    assert_select "form[action=?][method=?]", project_path(@project), "post" do

      assert_select "input#project_title[name=?]", "project[title]"

      assert_select "input#project_details[name=?]", "project[details]"

      assert_select "input#project_tenant_id[name=?]", "project[tenant_id]"
    end
  end
end
