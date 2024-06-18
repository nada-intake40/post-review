class PostsController < ApplicationController
    def create
      post = Post.new(post_params)
      post.user = User.find(params[:user_id])

      if post.save
        render json: post, status: :created
      else
        render json: post.errors, status: :unprocessable_entity
      end
    end

    def index
      posts = Post.where(user_id: params[:user_id]).page(params[:page])
      render json: posts
    end

    def top_posts
      top_posts = Post.joins(:reviews)
                      .group('posts.id')
                      .order('AVG(reviews.rating) DESC')
                      .page(params[:page])
      render json: top_posts
    end

  private

    def post_params
      params.require(:post).permit(:title, :body)
    end

end