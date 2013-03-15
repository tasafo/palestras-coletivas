require "spec_helper"

describe "Talk not found" do
  context "when talk does not exist" do
    before do
      visit root_path
      visit "/talks/00000111111000000111111"
    end

    it "redirects to the home page" do
      expect(current_path).to eql(root_path)
    end
  end
end