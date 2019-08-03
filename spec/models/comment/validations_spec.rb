require 'spec_helper'

describe Talk, 'validations' do
  let!(:comment) { create(:comment, :talk) }

  context 'when valid data' do
    it 'accepts valid attributes' do
      expect(comment).to be_valid
    end
  end

  it 'requires body' do
    comment.update(body: nil)

    expect(comment.errors[:body].size).to eq(1)
  end

  it 'requires user' do
    comment.update(user: nil)

    expect(comment.errors[:user].size).to eq(1)
  end
end
