class StaticPagesController < ApplicationController
  def top
    @users = User.order_followers.limit(15)
    @blogs = Blog.hottest(3)
  end

  def about
  end
end
