class CommentsController < ApplicationController
  before_filter :find_commentable

  def create
    comment_params = {user: current_user, commentable: find_parent_comment, body: params[:comment][:body] } 
    @new_comment = Comment.new.comment_on! comment_params

    if @new_comment.persisted?
      flash[:notice] = I18n.t("flash.comments.create.notice")
    else
      flash[:notice] = I18n.t("flash.comments.create.alert")
    end

    redirect_to @commentable
  end

  def destroy
    @comment = @commentable.find_comment_by_id params[:id]

    @comment.destroy
    flash[:notice] = I18n.t("flash.comments.destroy.notice")

    redirect_to @commentable
  end

  private

  def find_commentable
    commentable_class = params[:commentable_type].camelize.constantize
    @commentable = commentable_class.find(params[:commentable_id])
  end

  def find_parent_comment
    parent = @commentable.comments.find params[:comment_id] if params[:comment_id]
    parent ||= @commentable
  end
end 