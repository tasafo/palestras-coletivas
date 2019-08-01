require 'spec_helper'

describe 'Comment on talk', type: :request do
  it_behaves_like 'a commentable' do
    let!(:commentable) { create(:talk, users: [user], owner: user) }
    let(:commentable_path) { talk_path commentable }
  end
end
