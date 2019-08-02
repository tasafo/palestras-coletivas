require 'spec_helper'

describe 'Show public talk', type: :request do
  let!(:user) { create(:user, :paul) }
  let!(:talk) { create(:talk, users: [user], owner: user) }
  let!(:another_talk) { create(:another_talk, users: [user], owner: user) }
  let!(:spdeck_talk) { create(:speakerdeck_talk, users: [user], owner: user) }
  let!(:prezi_talk) { create(:prezi_talk, users: [user], owner: user) }

  context 'when logged' do
    before do
      login_as user, talks_path
    end

    context 'of slideshare' do
      before do
        click_link 'Compartilhe'
      end

      it 'displays detail talk' do
        expect(current_path).to eql(talk_path(talk))
        expect(page).to have_content('Compartilhe')
      end
    end

    context 'of speakerdeck' do
      before do
        click_link 'Ruby - praticamente falando'
      end

      it 'displays detail talk' do
        expect(current_path).to eql(talk_path(spdeck_talk))
        expect(page).to have_content('Ruby - praticamente falando')
      end
    end

    context 'of prezi' do
      before do
        click_link 'SOA - Introdução'
      end

      it 'displays detail talk' do
        expect(current_path).to eql(talk_path(prezi_talk))
        expect(page).to have_content('SOA - Introdução')
      end
    end

    context 'no slides' do
      before do
        click_link 'A história da informática'
      end

      it 'displays detail talk' do
        expect(current_path).to eql(talk_path(another_talk))
        expect(page).to have_content('A história da informática')
      end
    end
  end

  context 'when unlogged' do
    before do
      visit talk_path(talk)
    end

    it 'displays detail talk' do
      expect(current_path).to eql(talk_path(talk))
      expect(page).to have_content('Compartilhe')
    end
  end
end
