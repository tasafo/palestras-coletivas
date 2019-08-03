require 'spec_helper'

describe 'Add rating on event', js: true do
  it_behaves_like 'a rateable' do
    let!(:rateable) { create(:event, :tasafoconf, users: [user], owner: user) }
    let!(:rateable_path) { event_path rateable }
  end
end
