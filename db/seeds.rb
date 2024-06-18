# db/seeds.rb
User.destroy_all
Post.destroy_all
Review.destroy_all

users = []
50.times do
  users << User.create!(username: Faker::Internet.username)
end

50_000.times do
  Post.create!(
    title: Faker::Book.title,
    body: Faker::Lorem.paragraph,
    user: users.sample
  )
end

posts = Post.all

20_000.times do
  Review.create!(
    rating: rand(1..5),
    comment: Faker::Lorem.sentence,
    user: users.sample,
    post: posts.sample
  )
end
