require 'spec_helper'

describe EventCertificatesController, type: :controller do
  let!(:user)  { create(:user, :paul) }
  let!(:other_user) { create(:user, :billy) }
  let!(:event) { create(:event, :tasafoconf, owner: user) }
  let!(:talk)  { create(:talk, users: [ user ], owner: user) }
  let!(:schedule_palestra) { create(:schedule, :palestra, event: event, talk: talk) }
  let!(:enrollment_active) { create(:enrollment, event: event, user: other_user) }

  context 'GET: speakers' do
    it 'should to be success' do
      session[:user_id] = user.id

      params = { id: event.id.to_s }

      get :speakers, params.merge(format: 'json')

      expect(response.status).to eql(200)
    end
  end

  context 'GET: organizers' do
    it 'should to be success' do
      session[:user_id] = user.id

      params = { id: event.id.to_s }

      get :organizers, params.merge(format: 'json')

      expect(response.status).to eql(200)
    end
  end

  context 'GET: attendees' do
    it 'should to be success' do
      session[:user_id] = user.id

      params = { id: event.id.to_s, kind: 'attendees', user_id: 0 }

      get :participants, params.merge(format: 'json')

      expect(response.status).to eql(200)
    end
  end

  context 'GET: participants' do
    it 'should to be success' do
      session[:user_id] = user.id

      params = { id: event.id.to_s, kind: 'all', user_id: 0 }

      get :participants, params.merge(format: 'json')

      expect(response.status).to eql(200)
    end
  end

  context 'GET: participant' do
    it 'should to be success' do
      session[:user_id] = user.id

      params = { id: event.id.to_s, kind: 'user', user_id: user.id.to_s }

      get :participants, params.merge(format: 'json')

      expect(response.status).to eql(200)
    end
  end
end
