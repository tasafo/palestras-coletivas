require "spec_helper"

describe EventsController, :type => :controller do
  let!(:user) { create(:user, :paul) }
  let!(:event) { create(:event, :tasafoconf, owner: user) }

  context "GET: index" do
    it "should not to be nil" do
      params = { events: "all" }
      get :index, params.merge(format: 'json')
      
      parse_json = JSON(response.body)

      expect(parse_json).not_to be nil
    end
  end
end