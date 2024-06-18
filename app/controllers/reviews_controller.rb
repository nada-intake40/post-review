class ReviewsController < ApplicationController

    def create
        post = Post.find(params[:post_id])
        review = post.reviews.build(review_params)
        review.user = User.find(params[:user_id])
    
        if review.save
          render json: review, status: :created
        else
          render json: review.errors, status: :unprocessable_entity
        end
    end
    
    private
    
    def review_params
    params.require(:review).permit(:rating, :comment)
    end
end
