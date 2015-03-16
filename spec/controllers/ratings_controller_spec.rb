require "spec_helper"

describe RatingsController, :type => :controller do
  let!(:user) { create(:user, :paul) }
  let!(:event) { create(:event, :tasafoconf, owner: user) }

  context "POST: create" do
    it "should not to be nil" do
      session[:user_id] = user.id

      params = { rateable_type: "Event", rateable_id: event.id, rate: { my_rate: 4.0 } }

      post :create, params.merge(format: 'json')

      parse_json = JSON(response.body)

      expect(parse_json["success"]).not_to be nil
    end
  end
end