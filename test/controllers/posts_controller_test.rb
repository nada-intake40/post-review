# test/controllers/posts_controller_test.rb
require "test_helper"

class PostsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
  end

  test "should create post" do
    assert_difference('Post.count') do
      post posts_url, params: { post: { title: 'Test Title', body: 'Test Body' }, user_id: @user.id }
    end

    assert_response :created
  end

  test "should list user posts" do
    get posts_url, params: { user_id: @user.id }
    assert_response :success
  end

  test "should list top posts" do
    get top_posts_url
    assert_response :success
  end
end

# test/controllers/reviews_controller_test.rb
require "test_helper"

class ReviewsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    @post = posts(:one)
  end

  test "should create review" do
    assert_difference('Review.count') do
      post post_reviews_url(@post), params: { review: { rating: 5, comment: 'Great post!' }, user_id: @user.id }
    end

    assert_response :created
  end
end
