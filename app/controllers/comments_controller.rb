#:nodoc:
class CommentsController < ApplicationController
  before_action :find_commentable

  def create
    comment_params = {
      user: current_user,
      commentable: find_parent_comment,
      body: params[:comment][:body]
    }
    @new_comment = Comment.new.comment_on! comment_params

    if @new_comment.persisted?
      flash[:notice] = I18n.t('flash.comments.create.notice')
    else
      flash[:alert] = I18n.t('flash.comments.create.alert')
    end

    redirect_to @commentable
  end

  def destroy
    @comment = @commentable.find_comment_by_id params[:id]

    @comment.destroy

    redirect_to @commentable, notice: t('flash.comments.destroy.notice')
  end

  private

  def find_commentable
    commentable_class = params[:commentable_type]

    commentable_class = commentable_class.camelize.constantize

    @commentable = commentable_class.find(params[:commentable_id])
  end

  def find_parent_comment
    if params[:comment_id]
      parent = @commentable.comments.find params[:comment_id]
    end

    parent ||= @commentable
  end
end
