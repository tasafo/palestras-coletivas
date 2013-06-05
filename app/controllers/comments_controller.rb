class CommentsController < ApplicationController
  def create
    @commentable = find_commentable

    comment_params = {user: current_user, commentable: @commentable, body: params[:comment][:body] } 
    @comment = Comment.new.comment_on! comment_params

    if @comment.persisted?
      flash[:notice] = I18n.t("flash.comments.create.notice")
    else
      flash[:notice] = I18n.t("flash.comments.create.alert")
    end

    redirect_to @commentable
  end

  def answer
    @commentable = find_commentable
    @comment = @commentable.comments.find params[:comment_id]

    answer_params = {user: current_user, commentable: @comment, body: params[:comment][:body] } 
    @answer = Comment.new.comment_on! answer_params

    if @answer.persisted?
      flash[:notice] = I18n.t("flash.comments.create.notice")
    else
      flash[:notice] = I18n.t("flash.comments.create.alert")
    end

    redirect_to @commentable
  end

  def destroy
    @commentable = find_commentable

    @comment = find_comment_by_id @commentable, params[:id]

    @comment.destroy
    flash[:notice] = I18n.t("flash.comments.destroy.notice")

    redirect_to @commentable
  end

  private

  def find_commentable
    commentable_class = params[:commentable_type].camelize.constantize
    commentable_class.find(params[:commentable_id])
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