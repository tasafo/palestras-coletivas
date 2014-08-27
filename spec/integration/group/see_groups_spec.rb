require "spec_helper"

describe "See groups", :type => :request do
  let!(:user) { create(:user, :paul) }
  let!(:group) { create(:group, :tasafo, :users => [ user ], :owner => user.id) }
  let!(:other_group) { create(:group, :gurupa, :users => [ user ], :owner => user.id) }
  let!(:another_group) { create(:group, :invalid, :users => [ user ], :owner => user.id) }

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

  context "when group have gravatar" do
    before do
      visit root_path
      click_link "Grupos"
      click_link "Tá safo!"
    end

    it "redirects to the group page" do
      expect(current_path).to eql(group_path(group))
    end

    it "displays group" do
      expect(page).to have_content("Tá safo!")
    end
  end

  context "when group not have gravatar" do
    before do
      visit root_path
      click_link "Grupos"
      click_link "GURU-PA"
    end

    it "redirects to the group page" do
      expect(current_path).to eql(group_path(other_group))
    end

    it "displays group" do
      expect(page).to have_content("GURU-PA")
    end
  end

  context "when group not have gravatar" do
    before do
      visit group_path(another_group)
    end

    it "redirects to the group page" do
      expect(current_path).to eql(group_path(another_group))
    end

    it "displays group" do
      expect(page).to have_content("Invalid")
    end
  end

  context "when user events" do
    before do
      login_as(user)
      click_link "Grupos"
      click_link "Meus grupos"
    end

    it "redirects to the groups page" do
      expect(current_path).to eql(groups_path)
    end

    it "displays group" do
      expect(page).to have_content("Tá safo!")
    end
  end
end