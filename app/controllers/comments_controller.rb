class CommentsController < ApplicationController

  def create
    # 非同期通信でコメント投稿
    @blog = Blog.find(params[:blog_id])
    @comment_new = Comment.new
    @comment = current_user.comments.new(comment_params)
    @comment.blog_id = @blog.id
    @comment.save
    @comment.create_notice_comment
  end

  def destroy
    # 非同期通信でコメント削除
    @blog = Blog.find(params[:blog_id])
    @comment_new = Comment.new
    Comment.find_by(id: params[:id], blog_id: @blog.id).destroy
  end

  private

  def comment_params
    params.require(:comment).permit(:content, :parent_id)
  end

end