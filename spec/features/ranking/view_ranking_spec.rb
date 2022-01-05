require 'spec_helper'

describe 'View ranking' do
  before do
    visit ranking_path
  end

  it 'displays the Ranking title' do
    expect(page).to have_current_path(ranking_path)
    expect(page).to have_content('Classificação')
  end
end
