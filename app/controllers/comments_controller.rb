class CommentsController < ApplicationController

  before_filter :find_commentable

  def create
    @comment = @commentable.comments.find params[:comment_id] if params[:comment_id]
    @comment ||= @commentable

    comment_params = {user: current_user, commentable: @comment, body: params[:comment][:body] } 
    @new_comment = Comment.new.comment_on! comment_params

    if @new_comment.persisted?
      flash[:notice] = I18n.t("flash.comments.create.notice")
    else
      flash[:notice] = I18n.t("flash.comments.create.alert")
    end

    redirect_to @commentable
  end

  def destroy
    @comment = find_comment_by_id @commentable, params[:id]

    @comment.destroy
    flash[:notice] = I18n.t("flash.comments.destroy.notice")

    redirect_to @commentable
  end

  private

  def find_commentable
    commentable_class = params[:commentable_type].camelize.constantize
    @commentable = commentable_class.find(params[:commentable_id])
  end

  def find_comment_by_id commentable, id
    commentable.comments.find id
  rescue Mongoid::Errors::DocumentNotFound
    answers(commentable).find id
  end

  def answers commentable
    criteria = Comment.criteria
    criteria.documents << commentable.comments.map(&:comments)
    criteria.documents.flatten!
    criteria.embedded = true
    criteria.all
  end
end 