require "spec_helper"

describe GroupsController, :type => :controller do
  context "POST: info_url" do
    it "should instantiate gravatar" do
      post :info_url, :link => "http://gravatar.com/tasafo"
      expect(assigns[:gravatar]).to be_a_kind_of(Gravatar)
    end

    it "not should be success" do
      post :info_url, :link => "http://invalid.non/nonono"
      expect(response).not_to be_success
    end    
  end
end