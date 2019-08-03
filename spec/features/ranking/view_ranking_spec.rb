require 'spec_helper'

describe 'View ranking' do
  before do
    visit ranking_path
  end

  it 'displays the Ranking title' do
    expect(current_path).to eql(ranking_path)
    expect(page).to have_content('Ranking')
  end
end
