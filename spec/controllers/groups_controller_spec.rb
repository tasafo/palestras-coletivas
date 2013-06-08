require "spec_helper"

describe GroupsController do
  context "POST: info_url" do
    it "should instantiate gravatar" do
      post :info_url, :link => "http://gravatar.com/tasafo"
      assigns[:gravatar].should be_a_kind_of(Gravatar)
    end

    it "not should be success" do
      post :info_url, :link => "http://invalid.non/nonono"
      response.should_not be_success
    end    
  end
end