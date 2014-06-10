require "spec_helper"

describe CouncilDistrictsController do
  describe "routing" do

    it "routes to #index" do
      get("/council_districts").should route_to("council_districts#index")
    end

    it "routes to #new" do
      get("/council_districts/new").should route_to("council_districts#new")
    end

    it "routes to #show" do
      get("/council_districts/1").should route_to("council_districts#show", :id => "1")
    end

    it "routes to #edit" do
      get("/council_districts/1/edit").should route_to("council_districts#edit", :id => "1")
    end

    it "routes to #create" do
      post("/council_districts").should route_to("council_districts#create")
    end

    it "routes to #update" do
      put("/council_districts/1").should route_to("council_districts#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/council_districts/1").should route_to("council_districts#destroy", :id => "1")
    end

  end
end
