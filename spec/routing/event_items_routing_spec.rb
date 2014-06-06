require "spec_helper"

describe EventItemsController do
  describe "routing" do

    it "routes to #index" do
      get("/event_items").should route_to("event_items#index")
    end

    it "routes to #new" do
      get("/event_items/new").should route_to("event_items#new")
    end

    it "routes to #show" do
      get("/event_items/1").should route_to("event_items#show", :id => "1")
    end

    it "routes to #edit" do
      get("/event_items/1/edit").should route_to("event_items#edit", :id => "1")
    end

    it "routes to #create" do
      post("/event_items").should route_to("event_items#create")
    end

    it "routes to #update" do
      put("/event_items/1").should route_to("event_items#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/event_items/1").should route_to("event_items#destroy", :id => "1")
    end

  end
end
