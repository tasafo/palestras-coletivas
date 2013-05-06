require "spec_helper"

describe "Watch talk" do
  let!(:user) { create(:user, :paul) }
  let!(:talk) { create(:talk, :users => [ user ], :owner => user.id) }

  before do
    login_as(user)
    visit talk_path(talk)
  end

  it "toggle talk as watched" do
    click_link "Assistir"
    expect(page).to have_selector("a", :text => "Assisti! (desfazer)")

    click_link "Assisti! (desfazer)"
    expect(page).to have_selector("a", :text => "Assistir")
  end
end