require "spec_helper"

describe "View ranking", :type => :request do
  before do
    visit root_path
    click_link "Ranking"
  end

  it "redirects to the ranking page" do
    expect(current_path).to eql(ranking_path)
  end

  it "displays the Top 5 title" do
    expect(page).to have_content("Top 5")
  end
end
