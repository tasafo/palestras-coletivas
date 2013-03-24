require "spec_helper"

describe "See groups" do
  let!(:user) { create(:user, :paul) }
  let!(:group) { create(:group, :tasafo, :users => [ user ], :owner => user.id) }
  let!(:other_group) { create(:group, :gurupa, :users => [ user ], :owner => user.id) }

  context "with two groups" do
    before do
      visit root_path
      click_link "Grupos"
    end

    it "redirects to the home page" do
      expect(current_path).to eql(groups_path)
    end

    it "displays at least one group" do
      expect(page).to have_content("Tá safo!")
    end
  end
end