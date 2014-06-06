require 'spec_helper'

describe "events/show" do
  before(:each) do
    @event = assign(:event, stub_model(Event,
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
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    rendered.should match(/Event Guid/)
    rendered.should match(/Event Last Modified/)
    rendered.should match(/Event Last Modified Utc/)
    rendered.should match(/Event Row Version/)
    rendered.should match(/2/)
    rendered.should match(/Event Body Name/)
    rendered.should match(/Event Date/)
    rendered.should match(/Event Time/)
    rendered.should match(/Event Video Status/)
    rendered.should match(/3/)
    rendered.should match(/4/)
    rendered.should match(/Event Location/)
  end
end
