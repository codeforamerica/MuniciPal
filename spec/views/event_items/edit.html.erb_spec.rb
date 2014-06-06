require 'spec_helper'

describe "event_items/edit" do
  before(:each) do
    @event_item = assign(:event_item, stub_model(EventItem,
      :event_id => 1,
      :EventItemId => 1,
      :EventItemGuid => "MyString",
      :EventItemLastModified => "MyString",
      :EventItemLastModifiedUtc => "MyString",
      :EventItemRowVersion => "MyString",
      :EventItemEventId => 1,
      :EventItemAgendaSequence => 1,
      :EventItemMinutesSequence => 1,
      :EventItemAgendaNumber => "MyString",
      :EventItemVideo => "MyString",
      :EventItemVideoIndex => 1,
      :EventItemVersion => "MyString",
      :EventItemAgendaNote => "MyString",
      :EventItemMinutesNote => "",
      :EventItemActionId => 1,
      :EventItemAction => "MyString",
      :EventItemActionText => "MyText",
      :EventItemPassedFlag => 1,
      :EventItemPassedFlagText => "MyString",
      :EventItemRollCallFlag => 1,
      :EventItemFlagExtra => "",
      :EventItemTitle => "MyText",
      :EventItemTally => "",
      :EventItemConsent => 1,
      :EventItemMoverId => 1,
      :EventItemMover => "MyString",
      :EventItemSeconderId => 1,
      :EventItemSeconder => "MyString",
      :EventItemMatterId => 1,
      :EventItemMatterGuid => "MyString",
      :EventItemMatterFile => "MyString",
      :EventItemMatterName => "MyString",
      :EventItemMatterType => "MyString",
      :EventItemMatterStatus => "MyString"
    ))
  end

  it "renders the edit event_item form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", event_item_path(@event_item), "post" do
      assert_select "input#event_item_event_id[name=?]", "event_item[event_id]"
      assert_select "input#event_item_EventItemId[name=?]", "event_item[EventItemId]"
      assert_select "input#event_item_EventItemGuid[name=?]", "event_item[EventItemGuid]"
      assert_select "input#event_item_EventItemLastModified[name=?]", "event_item[EventItemLastModified]"
      assert_select "input#event_item_EventItemLastModifiedUtc[name=?]", "event_item[EventItemLastModifiedUtc]"
      assert_select "input#event_item_EventItemRowVersion[name=?]", "event_item[EventItemRowVersion]"
      assert_select "input#event_item_EventItemEventId[name=?]", "event_item[EventItemEventId]"
      assert_select "input#event_item_EventItemAgendaSequence[name=?]", "event_item[EventItemAgendaSequence]"
      assert_select "input#event_item_EventItemMinutesSequence[name=?]", "event_item[EventItemMinutesSequence]"
      assert_select "input#event_item_EventItemAgendaNumber[name=?]", "event_item[EventItemAgendaNumber]"
      assert_select "input#event_item_EventItemVideo[name=?]", "event_item[EventItemVideo]"
      assert_select "input#event_item_EventItemVideoIndex[name=?]", "event_item[EventItemVideoIndex]"
      assert_select "input#event_item_EventItemVersion[name=?]", "event_item[EventItemVersion]"
      assert_select "input#event_item_EventItemAgendaNote[name=?]", "event_item[EventItemAgendaNote]"
      assert_select "input#event_item_EventItemMinutesNote[name=?]", "event_item[EventItemMinutesNote]"
      assert_select "input#event_item_EventItemActionId[name=?]", "event_item[EventItemActionId]"
      assert_select "input#event_item_EventItemAction[name=?]", "event_item[EventItemAction]"
      assert_select "textarea#event_item_EventItemActionText[name=?]", "event_item[EventItemActionText]"
      assert_select "input#event_item_EventItemPassedFlag[name=?]", "event_item[EventItemPassedFlag]"
      assert_select "input#event_item_EventItemPassedFlagText[name=?]", "event_item[EventItemPassedFlagText]"
      assert_select "input#event_item_EventItemRollCallFlag[name=?]", "event_item[EventItemRollCallFlag]"
      assert_select "input#event_item_EventItemFlagExtra[name=?]", "event_item[EventItemFlagExtra]"
      assert_select "textarea#event_item_EventItemTitle[name=?]", "event_item[EventItemTitle]"
      assert_select "input#event_item_EventItemTally[name=?]", "event_item[EventItemTally]"
      assert_select "input#event_item_EventItemConsent[name=?]", "event_item[EventItemConsent]"
      assert_select "input#event_item_EventItemMoverId[name=?]", "event_item[EventItemMoverId]"
      assert_select "input#event_item_EventItemMover[name=?]", "event_item[EventItemMover]"
      assert_select "input#event_item_EventItemSeconderId[name=?]", "event_item[EventItemSeconderId]"
      assert_select "input#event_item_EventItemSeconder[name=?]", "event_item[EventItemSeconder]"
      assert_select "input#event_item_EventItemMatterId[name=?]", "event_item[EventItemMatterId]"
      assert_select "input#event_item_EventItemMatterGuid[name=?]", "event_item[EventItemMatterGuid]"
      assert_select "input#event_item_EventItemMatterFile[name=?]", "event_item[EventItemMatterFile]"
      assert_select "input#event_item_EventItemMatterName[name=?]", "event_item[EventItemMatterName]"
      assert_select "input#event_item_EventItemMatterType[name=?]", "event_item[EventItemMatterType]"
      assert_select "input#event_item_EventItemMatterStatus[name=?]", "event_item[EventItemMatterStatus]"
    end
  end
end
