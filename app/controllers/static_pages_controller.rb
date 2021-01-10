class StaticPagesController < ApplicationController
  def home
    if logged_in?
      @micropost = current_user.microposts.build #You can also write .new in place of .build
      @feed_items = current_user.feed.paginate(page: params[:page])
    end
  end

  def help
  end

  def about
  end

  def contact
  end
end
