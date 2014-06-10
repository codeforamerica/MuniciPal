require 'spec_helper'

describe "council_districts/show" do
  before(:each) do
    @council_district = assign(:council_district, stub_model(CouncilDistrict))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
