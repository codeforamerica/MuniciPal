require 'spec_helper'

describe "event_items/index" do
  before(:each) do
    assign(:event_items, [
      stub_model(EventItem,
        :event_id => 1,
        :EventItemId => 2,
        :EventItemGuid => "Event Item Guid",
        :EventItemLastModified => "Event Item Last Modified",
        :EventItemLastModifiedUtc => "Event Item Last Modified Utc",
        :EventItemRowVersion => "Event Item Row Version",
        :EventItemEventId => 3,
        :EventItemAgendaSequence => 4,
        :EventItemMinutesSequence => 5,
        :EventItemAgendaNumber => "Event Item Agenda Number",
        :EventItemVideo => "Event Item Video",
        :EventItemVideoIndex => 6,
        :EventItemVersion => "Event Item Version",
        :EventItemAgendaNote => "Event Item Agenda Note",
        :EventItemMinutesNote => "",
        :EventItemActionId => 7,
        :EventItemAction => "Event Item Action",
        :EventItemActionText => "MyText",
        :EventItemPassedFlag => 8,
        :EventItemPassedFlagText => "Event Item Passed Flag Text",
        :EventItemRollCallFlag => 9,
        :EventItemFlagExtra => "",
        :EventItemTitle => "MyText",
        :EventItemTally => "",
        :EventItemConsent => 10,
        :EventItemMoverId => 11,
        :EventItemMover => "Event Item Mover",
        :EventItemSeconderId => 12,
        :EventItemSeconder => "Event Item Seconder",
        :EventItemMatterId => 13,
        :EventItemMatterGuid => "Event Item Matter Guid",
        :EventItemMatterFile => "Event Item Matter File",
        :EventItemMatterName => "Event Item Matter Name",
        :EventItemMatterType => "Event Item Matter Type",
        :EventItemMatterStatus => "Event Item Matter Status"
      ),
      stub_model(EventItem,
        :event_id => 1,
        :EventItemId => 2,
        :EventItemGuid => "Event Item Guid",
        :EventItemLastModified => "Event Item Last Modified",
        :EventItemLastModifiedUtc => "Event Item Last Modified Utc",
        :EventItemRowVersion => "Event Item Row Version",
        :EventItemEventId => 3,
        :EventItemAgendaSequence => 4,
        :EventItemMinutesSequence => 5,
        :EventItemAgendaNumber => "Event Item Agenda Number",
        :EventItemVideo => "Event Item Video",
        :EventItemVideoIndex => 6,
        :EventItemVersion => "Event Item Version",
        :EventItemAgendaNote => "Event Item Agenda Note",
        :EventItemMinutesNote => "",
        :EventItemActionId => 7,
        :EventItemAction => "Event Item Action",
        :EventItemActionText => "MyText",
        :EventItemPassedFlag => 8,
        :EventItemPassedFlagText => "Event Item Passed Flag Text",
        :EventItemRollCallFlag => 9,
        :EventItemFlagExtra => "",
        :EventItemTitle => "MyText",
        :EventItemTally => "",
        :EventItemConsent => 10,
        :EventItemMoverId => 11,
        :EventItemMover => "Event Item Mover",
        :EventItemSeconderId => 12,
        :EventItemSeconder => "Event Item Seconder",
        :EventItemMatterId => 13,
        :EventItemMatterGuid => "Event Item Matter Guid",
        :EventItemMatterFile => "Event Item Matter File",
        :EventItemMatterName => "Event Item Matter Name",
        :EventItemMatterType => "Event Item Matter Type",
        :EventItemMatterStatus => "Event Item Matter Status"
      )
    ])
  end

  it "renders a list of event_items" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => "Event Item Guid".to_s, :count => 2
    assert_select "tr>td", :text => "Event Item Last Modified".to_s, :count => 2
    assert_select "tr>td", :text => "Event Item Last Modified Utc".to_s, :count => 2
    assert_select "tr>td", :text => "Event Item Row Version".to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
    assert_select "tr>td", :text => 4.to_s, :count => 2
    assert_select "tr>td", :text => 5.to_s, :count => 2
    assert_select "tr>td", :text => "Event Item Agenda Number".to_s, :count => 2
    assert_select "tr>td", :text => "Event Item Video".to_s, :count => 2
    assert_select "tr>td", :text => 6.to_s, :count => 2
    assert_select "tr>td", :text => "Event Item Version".to_s, :count => 2
    assert_select "tr>td", :text => "Event Item Agenda Note".to_s, :count => 2
    assert_select "tr>td", :text => "".to_s, :count => 2
    assert_select "tr>td", :text => 7.to_s, :count => 2
    assert_select "tr>td", :text => "Event Item Action".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => 8.to_s, :count => 2
    assert_select "tr>td", :text => "Event Item Passed Flag Text".to_s, :count => 2
    assert_select "tr>td", :text => 9.to_s, :count => 2
    assert_select "tr>td", :text => "".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => "".to_s, :count => 2
    assert_select "tr>td", :text => 10.to_s, :count => 2
    assert_select "tr>td", :text => 11.to_s, :count => 2
    assert_select "tr>td", :text => "Event Item Mover".to_s, :count => 2
    assert_select "tr>td", :text => 12.to_s, :count => 2
    assert_select "tr>td", :text => "Event Item Seconder".to_s, :count => 2
    assert_select "tr>td", :text => 13.to_s, :count => 2
    assert_select "tr>td", :text => "Event Item Matter Guid".to_s, :count => 2
    assert_select "tr>td", :text => "Event Item Matter File".to_s, :count => 2
    assert_select "tr>td", :text => "Event Item Matter Name".to_s, :count => 2
    assert_select "tr>td", :text => "Event Item Matter Type".to_s, :count => 2
    assert_select "tr>td", :text => "Event Item Matter Status".to_s, :count => 2
  end
end
