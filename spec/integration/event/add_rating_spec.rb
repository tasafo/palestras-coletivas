require "spec_helper"

describe "Add ratign on event", :js => true do
  it_behaves_like "a rateable" do
    let!(:rateable)     { create(:event, :tasafoconf, :users => [ user ], :owner => user.id) }
    let(:rateable_path) { event_path rateable }
  end
end