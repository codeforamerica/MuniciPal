require 'spec_helper'

describe "event_items/show" do
  before(:each) do
    @event_item = assign(:event_item, stub_model(EventItem,
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
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    rendered.should match(/2/)
    rendered.should match(/Event Item Guid/)
    rendered.should match(/Event Item Last Modified/)
    rendered.should match(/Event Item Last Modified Utc/)
    rendered.should match(/Event Item Row Version/)
    rendered.should match(/3/)
    rendered.should match(/4/)
    rendered.should match(/5/)
    rendered.should match(/Event Item Agenda Number/)
    rendered.should match(/Event Item Video/)
    rendered.should match(/6/)
    rendered.should match(/Event Item Version/)
    rendered.should match(/Event Item Agenda Note/)
    rendered.should match(//)
    rendered.should match(/7/)
    rendered.should match(/Event Item Action/)
    rendered.should match(/MyText/)
    rendered.should match(/8/)
    rendered.should match(/Event Item Passed Flag Text/)
    rendered.should match(/9/)
    rendered.should match(//)
    rendered.should match(/MyText/)
    rendered.should match(//)
    rendered.should match(/10/)
    rendered.should match(/11/)
    rendered.should match(/Event Item Mover/)
    rendered.should match(/12/)
    rendered.should match(/Event Item Seconder/)
    rendered.should match(/13/)
    rendered.should match(/Event Item Matter Guid/)
    rendered.should match(/Event Item Matter File/)
    rendered.should match(/Event Item Matter Name/)
    rendered.should match(/Event Item Matter Type/)
    rendered.should match(/Event Item Matter Status/)
  end
end
