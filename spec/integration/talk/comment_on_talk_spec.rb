require "spec_helper"

describe "Comment on talk" do
  it_behaves_like "a commentable" do
    let!(:commentable) { create(:talk, :users => [ user ], :owner => user.id) }
    let(:commentable_path)  { talk_path commentable }
  end
end