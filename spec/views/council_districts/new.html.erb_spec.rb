require 'spec_helper'

describe "council_districts/new" do
  before(:each) do
    assign(:council_district, stub_model(CouncilDistrict).as_new_record)
  end

  it "renders new council_district form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", council_districts_path, "post" do
    end
  end
end
