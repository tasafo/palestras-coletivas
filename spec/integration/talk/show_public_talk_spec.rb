require "spec_helper"

describe "Show public talk", :type => :request do
  let!(:user) { create(:user, :paul) }
  let!(:talk) { create(:talk, :users => [ user ], :owner => user.id) }
  let!(:another_talk) { create(:another_talk, :users => [ user ], :owner => user.id) }
  let!(:speakerdeck_talk) { create(:speakerdeck_talk, :users => [ user ], :owner => user.id) }

  context "of slideshare" do
    before do
      login_as(user)
      visit root_path
      click_link "Palestras"
      click_link "Compartilhe"
    end

    it "redirects to the show page" do
      expect(current_path).to eql(talk_path(talk))
    end

    it "displays detail talk" do
      expect(page).to have_content("Compartilhe")
    end
  end

  context "of speakerdeck" do
    before do
      login_as(user)
      visit root_path
      click_link "Palestras"
      click_link "Ruby - praticamente falando"
    end

    it "redirects to the show page" do
      expect(current_path).to eql(talk_path(speakerdeck_talk))
    end

    it "displays detail talk" do
      expect(page).to have_content("Ruby - praticamente falando")
    end
  end

  context "no slides" do
    before do
      login_as(user)
      visit root_path
      click_link "Palestras"
      click_link "A história da informática"
    end

    it "redirects to the show page" do
      expect(current_path).to eql(talk_path(another_talk))
    end

    it "displays detail talk" do
      expect(page).to have_content("A história da informática")
    end
  end

  context "when unlogged" do
    before do
      visit root_path
      visit talk_path(talk)
    end

    it "redirects to the show page" do
      expect(current_path).to eql(talk_path(talk))
    end

    it "displays detail talk" do
      expect(page).to have_content("Compartilhe")
    end
  end
end
