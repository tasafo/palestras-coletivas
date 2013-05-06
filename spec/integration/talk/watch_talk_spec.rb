require "spec_helper"

describe "Watch talk" do
  let!(:user) { create(:user, :paul) }
  let!(:talk) { create(:talk, :users => [ user ], :owner => user.id) }

  before do
    login_as(user)
    visit talk_path(talk)
  end

  it "toggle talk as watched" do
    expect(page).to have_selector("span.watched_user", :count => 0)

    click_link "Assistir"
    expect(page).to have_selector("span.watched_user", :count => 1)

    click_link "Assisti! (desfazer)"
    expect(page).to have_selector("a", :text => "Assistir")
    expect(page).to have_selector("span.watched_user", :count => 0)
  end
end