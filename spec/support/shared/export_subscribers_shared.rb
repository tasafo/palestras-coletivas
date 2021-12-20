shared_examples_for 'get profiles' do |user1, user2, message, status|
  let!(:user) { create(:user, user1) }
  let!(:other_user) { create(:user, user2) }
  let!(:event) { create(:event, :tasafoconf, owner: user, users: [user]) }

  it message do
    session[:user_id] = (user1 == user2 ? user : other_user).id

    params = { event_id: event.slug }

    get :new, params: params.merge(format: 'html')

    expect(response.status).to eql(status)
  end
end

shared_examples_for 'csv params' do |profile_en, profile_pt|
  let!(:user) { create(:user, :paul) }
  let!(:event) { create(:event, :tasafoconf, owner: user, users: [user]) }
  let(:csv_string) { ExportSubscriber.as_csv(event, profile_en) }
  let(:csv_options) do
    {
      filename: "certifico_ta-safo-conf-2012_#{profile_pt}.csv",
      type: 'text/csv'
    }
  end

  before do
    expect(@controller).to receive(:send_data).with(csv_string, csv_options)
  end

  it 'streams the result as a csv file' do
    session[:user_id] = user.id

    params = { event_id: event.slug, profile: profile_en }

    post :create, params: params.merge(format: 'html')
  end
end
