require "spec_helper"

describe "Watch talk" do
  let!(:user) { create(:user, :paul) }
  let!(:other_user) { create(:user, :billy) }
  let!(:talk) { create(:talk, :users => [ user ], :owner => user.id) }

  before do
    login_as(other_user)
    visit talk_path(talk)
  end

  it "mark and unmark talk as watched" do
    expect(page).to have_selector("span.watched_user", :count => 0)

    click_link "Já assisti!"
    expect(page).to have_selector("span.watched_user", :count => 1)

    click_link "Já assisti! (desfazer)"
    expect(page).to have_selector("a", :text => "Já assisti!")
    expect(page).to have_selector("span.watched_user", :count => 0)
  end
end