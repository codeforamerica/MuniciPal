require 'spec_helper'

describe "events/index" do
  before(:each) do
    assign(:events, [
      stub_model(Event,
        :EventId => 1,
        :EventGuid => "Event Guid",
        :EventLastModified => "Event Last Modified",
        :EventLastModifiedUtc => "Event Last Modified Utc",
        :EventRowVersion => "Event Row Version",
        :EventBodyId => 2,
        :EventBodyName => "Event Body Name",
        :EventDate => "Event Date",
        :EventTime => "Event Time",
        :EventVideoStatus => "Event Video Status",
        :EventAgendaStatusId => 3,
        :EventMinutesStatusId => 4,
        :EventLocation => "Event Location"
      ),
      stub_model(Event,
        :EventId => 1,
        :EventGuid => "Event Guid",
        :EventLastModified => "Event Last Modified",
        :EventLastModifiedUtc => "Event Last Modified Utc",
        :EventRowVersion => "Event Row Version",
        :EventBodyId => 2,
        :EventBodyName => "Event Body Name",
        :EventDate => "Event Date",
        :EventTime => "Event Time",
        :EventVideoStatus => "Event Video Status",
        :EventAgendaStatusId => 3,
        :EventMinutesStatusId => 4,
        :EventLocation => "Event Location"
      )
    ])
  end

  it "renders a list of events" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => "Event Guid".to_s, :count => 2
    assert_select "tr>td", :text => "Event Last Modified".to_s, :count => 2
    assert_select "tr>td", :text => "Event Last Modified Utc".to_s, :count => 2
    assert_select "tr>td", :text => "Event Row Version".to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => "Event Body Name".to_s, :count => 2
    assert_select "tr>td", :text => "Event Date".to_s, :count => 2
    assert_select "tr>td", :text => "Event Time".to_s, :count => 2
    assert_select "tr>td", :text => "Event Video Status".to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
    assert_select "tr>td", :text => 4.to_s, :count => 2
    assert_select "tr>td", :text => "Event Location".to_s, :count => 2
  end
end
