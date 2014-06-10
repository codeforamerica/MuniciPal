require 'spec_helper'

describe "council_districts/index" do
  before(:each) do
    assign(:council_districts, [
      stub_model(CouncilDistrict),
      stub_model(CouncilDistrict)
    ])
  end

  it "renders a list of council_districts" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
