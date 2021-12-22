module Commentable
  def find_comment_by_id(id)
    search = Comment.criteria
    search = comments.merge search
    comments.each do |comment|
      search.documents += comment.comments
    end
    search.find id
  end
end
