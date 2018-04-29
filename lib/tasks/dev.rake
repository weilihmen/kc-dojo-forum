namespace :dev do

  task F10_users: :environment do
    10.times do |i|
      user_name = FFaker::Name.first_name
      User.create(
        name: "#{user_name}",
        intro: FFaker::Lorem.sentence,
        email: "#{user_name}@com",
        password: "12345678",
      )
    end
    puts "F10_users done"
  end
  
  task F25_posts: :environment do
    25.times do |i|
      c_id=Category.all.sample.id
      status=["pending", "publish"].sample
      Post.create(
        user: User.all.sample,
        title: FFaker::Lorem.word,
        content: FFaker::Lorem.paragraph,
        status: status,
        category_ids: [c_id],
      )
    end
    puts "F25_posts done"
  end

  task F50_comments: :environment do
    50.times do |i|
        Comment.create(
          content: FFaker::Lorem.sentence,
          user: User.all.sample,
          post: Post.all.sample
        )
    end
    puts "F50_comments done"
  end

  task F50_likes: :environment do
    50.times do |i|
        Like.create(
          user: User.all.sample,
          post: Post.all.sample
        )
    end
    puts "F50_likes done"
  end

  task F25_friendships: :environment do
    25.times do |i|
      status=["pending", "approved"].sample
      Friendship.create(
        user: User.all.sample,
        friend: User.all.sample,
        status: status
        )
    end
    puts "F25_friendships done"
  end

  task F_ALL: :environment do
    Rake::Task["db:seed"].execute
    Rake::Task["dev:F10_users"].execute
    Rake::Task["dev:F25_posts"].execute
    Rake::Task["dev:F50_comments"].execute
    Rake::Task["dev:F50_likes"].execute
    Rake::Task["dev:F25_friendships"].execute
    
    puts "F_ALL done"
  end

  task D_ALL: :environment do
    Post.all.destroy_all
    Comment.all.destroy_all
    User.all.destroy_all
    Category.all.destroy_all
    Like.all.destroy_all
    Friendship.all.destroy_all
    
    puts "D_ALL done"
  end

end