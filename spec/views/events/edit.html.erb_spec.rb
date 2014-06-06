require 'spec_helper'

describe "events/edit" do
  before(:each) do
    @event = assign(:event, stub_model(Event,
      :EventId => 1,
      :EventGuid => "MyString",
      :EventLastModified => "MyString",
      :EventLastModifiedUtc => "MyString",
      :EventRowVersion => "MyString",
      :EventBodyId => 1,
      :EventBodyName => "MyString",
      :EventDate => "MyString",
      :EventTime => "MyString",
      :EventVideoStatus => "MyString",
      :EventAgendaStatusId => 1,
      :EventMinutesStatusId => 1,
      :EventLocation => "MyString"
    ))
  end

  it "renders the edit event form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", event_path(@event), "post" do
      assert_select "input#event_EventId[name=?]", "event[EventId]"
      assert_select "input#event_EventGuid[name=?]", "event[EventGuid]"
      assert_select "input#event_EventLastModified[name=?]", "event[EventLastModified]"
      assert_select "input#event_EventLastModifiedUtc[name=?]", "event[EventLastModifiedUtc]"
      assert_select "input#event_EventRowVersion[name=?]", "event[EventRowVersion]"
      assert_select "input#event_EventBodyId[name=?]", "event[EventBodyId]"
      assert_select "input#event_EventBodyName[name=?]", "event[EventBodyName]"
      assert_select "input#event_EventDate[name=?]", "event[EventDate]"
      assert_select "input#event_EventTime[name=?]", "event[EventTime]"
      assert_select "input#event_EventVideoStatus[name=?]", "event[EventVideoStatus]"
      assert_select "input#event_EventAgendaStatusId[name=?]", "event[EventAgendaStatusId]"
      assert_select "input#event_EventMinutesStatusId[name=?]", "event[EventMinutesStatusId]"
      assert_select "input#event_EventLocation[name=?]", "event[EventLocation]"
    end
  end
end
