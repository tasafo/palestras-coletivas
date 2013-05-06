require "spec_helper"

describe "Watch talk" do
  let!(:user) { create(:user, :paul) }
  let!(:talk) { create(:talk, :users => [ user ], :owner => user.id) }

  before do
    login_as(user)
    visit talk_path(talk)
  end

  it "toggle talk as watched" do
    click_link "Não assisti"
    expect(page).to have_content("Assisti!")

    click_link "Assisti!"
    expect(page).to have_content("Não assisti")
  end
end