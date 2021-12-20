require 'spec_helper'

describe ExportSubscribersController do
  let!(:user) { create(:user, :paul) }
  let!(:other_user) { create(:user, :billy) }
  let!(:another_user) { create(:user, :luis) }

  let!(:event) { create(:event, :tasafoconf, owner: user, users: [user]) }

  let!(:talk) { create(:talk, users: [user], owner: user) }
  let!(:another_talk) { create(:another_talk, users: [user], owner: user) }

  let!(:schedule_palestra1) do
    create(:schedule, :palestra, event: event, talk: talk)
  end
  let!(:schedule_palestra2) do
    create(:schedule, :palestra, event: event, talk: another_talk)
  end

  let!(:enrollment_active) do
    create(:enrollment, event: event, user: other_user)
  end
  let!(:enrollment_inactive) do
    create(:enrollment, active: false, event: event, user: another_user)
  end

  context 'GET: profiles' do
    include_examples 'get profiles', 'paul', 'paul', 'should to be success', 200
    include_examples 'get profiles', 'paul', 'billy', 'unauthorized access', 302
  end

  context 'Export data with speakers profile' do
    include_examples 'csv params', 'speakers', 'palestrantes'
  end

  context 'Export data with organizers profile' do
    include_examples 'csv params', 'organizers', 'organizacao'
  end

  context 'Export data with participants profile' do
    include_examples 'csv params', 'participants', 'participantes'
  end
end
