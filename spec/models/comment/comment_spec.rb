require 'spec_helper'

describe Comment, type: :model do
  let!(:talk_owner) { create(:user, :random) }
  let!(:commentable)  { create(:talk, users: [talk_owner], owner: talk_owner.id.to_s) }

  let(:commentor) { create :user, :paul }

  context 'when commenting on commentable' do
    let(:new_comment)   { Comment.new }
    let(:body)          { 'Go reds!' }
    let(:params)        { { commentable: commentable, user: commentor, body: body } }

    it 'comments on commentable' do
      expect(commentable.comments.count).to be_eql 0
      new_comment.comment_on! params
      expect(commentable.comments.count).to be_eql 1
    end

    it 'sets user' do
      new_comment.comment_on! params
      expect(new_comment.user).to be_eql commentor
    end

    it 'sets body' do
      new_comment.comment_on! params
      expect(new_comment.body).to be_eql body
    end

    it 'persists comment' do
      expect(new_comment).to_not be_persisted
      new_comment.comment_on! params
      expect(new_comment).to be_persisted
    end
  end

  describe '#commented_by?' do
    it 'checks if comment was created by user' do
      comment = Comment.new

      comment.user = talk_owner
      expect(comment.commented_by?(commentor)).to be false

      comment.user = commentor
      expect(comment.commented_by?(commentor)).to be true
    end
  end
end
