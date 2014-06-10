require 'spec_helper'

describe "council_districts/edit" do
  before(:each) do
    @council_district = assign(:council_district, stub_model(CouncilDistrict))
  end

  it "renders the edit council_district form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", council_district_path(@council_district), "post" do
    end
  end
end
