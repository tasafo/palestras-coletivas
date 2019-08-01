require 'spec_helper'

describe 'Comment on event', type: :request do
  it_behaves_like 'a commentable' do
    let!(:commentable) do
      create(:event, :tasafoconf, users: [user], owner: user)
    end
    let(:commentable_path) { event_path commentable }
  end
end
