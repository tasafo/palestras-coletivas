require 'spec_helper'

describe ExportSubscribersController, type: :controller do
  let!(:user) { create(:user, :paul) }
  let!(:other_user) { create(:user, :billy) }
  let!(:another_user) { create(:user, :luis) }

  let!(:event) { create(:event, :tasafoconf, owner: user, users: [ user ]) }

  let!(:talk) { create(:talk, users: [ user ], owner: user) }
  let!(:another_talk) { create(:another_talk, users: [ user ], owner: user) }

  let!(:schedule_palestra_1) { create(:schedule, :palestra, event: event, talk: talk) }
  let!(:schedule_palestra_2) { create(:schedule, :palestra, event: event, talk: another_talk) }

  let!(:enrollment_active) { create(:enrollment, event: event, user: other_user) }
  let!(:enrollment_inactive) { create(:enrollment, active: false, event: event, user: another_user) }

  context 'GET: profiles' do
    it 'should to be success' do
      session[:user_id] = user.id

      params = { event_id: event._slugs[0] }

      get :new, params: params.merge(format: 'html')

      expect(response.status).to eql(200)
    end
  end

  context 'Export data with speakers profile' do
    let(:csv_string)  { ExportSubscriber.as_csv(event, 'speakers') }
    let(:csv_options) { { filename: 'certifico_ta-safo-conf-2012_palestrantes.csv', type: 'text/csv' } }

    before do
      expect(@controller).to receive(:send_data)
        .with(csv_string, csv_options) { @controller.render nothing: true }
    end

    it "streams the result as a csv file" do
      session[:user_id] = user.id

      params = { event_id: event._slugs[0], profile: 'speakers' }

      post :create, params: params.merge(format: 'html')
    end
  end

  context 'Export data with organizers profile' do
    let(:csv_string)  { ExportSubscriber.as_csv(event, 'organizers') }
    let(:csv_options) { { filename: 'certifico_ta-safo-conf-2012_organizacao.csv', type: 'text/csv' } }

    before do
      expect(@controller).to receive(:send_data)
        .with(csv_string, csv_options) { @controller.render nothing: true }
    end

    it "streams the result as a csv file" do
      session[:user_id] = user.id

      params = { event_id: event._slugs[0], profile: 'organizers' }

      post :create, params: params.merge(format: 'html')
    end
  end

  context 'Export data with participants profile' do
    let(:csv_string)  { ExportSubscriber.as_csv(event, 'participants') }
    let(:csv_options) { { filename: 'certifico_ta-safo-conf-2012_participantes.csv', type: 'text/csv' } }

    before do
      expect(@controller).to receive(:send_data)
        .with(csv_string, csv_options) { @controller.render nothing: true }
    end

    it "streams the result as a csv file" do
      session[:user_id] = user.id

      params = { event_id: event._slugs[0], profile: 'participants' }

      post :create, params: params.merge(format: 'html')
    end
  end
end
