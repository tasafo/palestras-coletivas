require "spec_helper"

describe "Home page" do
  context "with some talks" do
    before do
      visit root_path
    end

    it "redirects to home page" do
      expect(current_path).to eql(root_path)
    end

    it "displays access my account" do
      expect(page).to have_content("Acessar minha conta")
    end
  end
end