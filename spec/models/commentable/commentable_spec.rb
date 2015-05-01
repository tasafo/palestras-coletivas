require 'spec_helper'

describe Commentable, :type => :model do
  class DummyTalk
    include Mongoid::Document
    include Commentable
    embeds_many :comments, :as => :commentable
  end

  subject { DummyTalk.new }

  context "when finding comment by id" do
    it "finds from direct comments" do
      comment  = subject.comments.build :body => "Hello!"
      comment2 = subject.comments.build :body => "I am not here!"

      expect(subject.find_comment_by_id(comment.id)).to eq comment

    end
    it "finds among comment answers" do
      comment = subject.comments.build :body => "Hello!"
      comment2 = subject.comments.build :body => "I am not here!"

      answer = comment.comments.build :body => "Bye!"
      answer2 = comment.comments.build :body => "Dont go!"

      expect(subject.find_comment_by_id(answer.id)).to eq answer
    end
  end
end