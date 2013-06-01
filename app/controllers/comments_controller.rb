class CommentsController < ApplicationController
  def create
    commentable_class = params[:commentable_type].camelize.constantize
    @commentable = commentable_class.find(params[:commentable_id])

    comment_params = {user: current_user, commentable: @commentable, body: params[:comment][:body] } 
    @comment = Comment.new.comment_on! comment_params

    if @comment.persisted?
      flash[:notice] = I18n.t("flash.comments.create.notice")
    else
      flash[:notice] = I18n.t("flash.comments.create.alert")
    end

    redirect_to @commentable
  end
end 