require 'spec_helper'

describe 'Event not found' do
  let!(:user) { create(:user, :paul) }
  let!(:other_user) { create(:user, :billy) }
  let!(:event) do
    create(
      :event,
      :tasafoconf,
      to_public: false,
      users: [user],
      owner: user
    )
  end

  context 'when event does not exist' do
    before do
      visit '/events/00000111111000000111111'
    end

    it 'displays error message' do
      expect(current_path).to eql(events_path)
      page.has_content? 'Evento não encontrado(a)'
    end
  end

  context 'when the user is logged and the event is not public' do
    before do
      login_as other_user, event_path(event)
    end

    it 'displays error message' do
      expect(current_path).to eql(events_path)
      page.has_content? 'Evento não encontrado(a)'
    end
  end

  context 'when the user is not logged and the event is not public' do
    before do
      visit event_path(event)
    end

    it 'displays error message' do
      expect(current_path).to eql(events_path)
      page.has_content? 'Evento não encontrado(a)'
    end
  end
end
