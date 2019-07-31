require 'spec_helper'

describe 'View ranking', type: :request do
  before do
    visit root_path
    visit ranking_path
  end

  it 'redirects to the ranking page' do
    expect(current_path).to eql(ranking_path)
  end

  it 'displays the Ranking title' do
    expect(page).to have_content('Ranking')
  end
end
