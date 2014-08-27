require "spec_helper"

describe "Group not found", :type => :request do
  context "when group does not exist" do
    before do
      visit root_path
      visit "/groups/00000111111000000111111"
    end

    it "redirects to the home page" do
      expect(current_path).to eql(root_path)
    end
  end
end