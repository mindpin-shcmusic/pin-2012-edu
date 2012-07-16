# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Emanuel', :city => cities.first)

# 用户
ActiveRecord::Base.connection.execute("TRUNCATE TABLE users")
ActiveRecord::Base.connection.execute("INSERT INTO `users` (`id`, `name`, `hashed_password`, `salt`, `email`, `sign`, `activation_code`, `logo_file_name`, `logo_content_type`, `logo_file_size`, `logo_updated_at`, `activated_at`, `reset_password_code`, `reset_password_code_until`, `last_login_time`, `send_invite_email`, `reputation`, `created_at`, `updated_at`) VALUES
(1, 'luffy', 'aad7cb0bfbd8e9627383e8f291dc5084673e8f06', '-6397734380.692534063914668', 'kingla_pei@163.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2012-03-23 05:18:04', NULL, 0, '2012-03-22 08:31:15', '2012-03-23 05:18:05'),
(2, 'test2user', 'aad7cb0bfbd8e9627383e8f291dc5084673e8f06', '-6397734380.692534063914668', 'kingla_pei@163.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL),
(3, 'test3user', 'aad7cb0bfbd8e9627383e8f291dc5084673e8f06', '-6397734380.692534063914668', 'kingla_pei@163.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL)")

# 投票
ActiveRecord::Base.connection.execute("TRUNCATE TABLE votes")
ActiveRecord::Base.connection.execute("TRUNCATE TABLE vote_items")
ActiveRecord::Base.connection.execute("TRUNCATE TABLE vote_result_items")
ActiveRecord::Base.connection.execute("TRUNCATE TABLE vote_results")

ActiveRecord::Base.connection.execute("INSERT INTO `votes` (`id`, `creator_id`, `title`, `select_limit`, `created_at`, `updated_at`, `kind`) VALUES
(1, 1, 'user1, vote1', 1, NULL, NULL, 'TEXT'),
(2, 1, 'user1, vote2', 1, NULL, NULL, 'TEXT'),
(3, 1, 'user1, vote3', 2, NULL, NULL, 'TEXT'),
(4, 2, 'user2, vote1', 1, NULL, NULL, 'TEXT')")

# 投票选项
ActiveRecord::Base.connection.execute("INSERT INTO `vote_items` (`id`, `vote_id`, `item_title`, `created_at`, `updated_at`, `image_file_name`, `image_content_type`, `image_file_size`, `image_updated_at`) VALUES
(1, 1, 'vote1, title1', NULL, NULL, NULL, NULL, NULL, NULL),
(2, 1, 'vote1, title2', NULL, NULL, NULL, NULL, NULL, NULL),
(3, 1, 'vote1, title3', NULL, NULL, NULL, NULL, NULL, NULL),
(4, 2, 'vote2, title1', NULL, NULL, NULL, NULL, NULL, NULL),
(5, 2, 'vote2, title2', NULL, NULL, NULL, NULL, NULL, NULL),
(6, 3, 'vote3, title1', NULL, NULL, NULL, NULL, NULL, NULL),
(7, 3, 'vote3, title2', NULL, NULL, NULL, NULL, NULL, NULL),
(8, 3, 'vote3, title3', NULL, NULL, NULL, NULL, NULL, NULL)")

# 问题

ActiveRecord::Base.connection.execute("TRUNCATE TABLE questions")
ActiveRecord::Base.connection.execute("TRUNCATE TABLE answers")
ActiveRecord::Base.connection.execute("INSERT INTO `questions` (`id`, `creator_id`, `title`, `content`, `created_at`, `updated_at`) VALUES
(1, 1, 'User 1, Question 1', 'User 1, Conetnt 1', '2012-03-26 02:43:36', '2012-03-26 02:43:36'),
(2, 1, 'User 1, Question 2', 'User 2, Conetnt 2', '2012-03-26 02:43:36', '2012-03-26 02:43:36'),
(3, 1, 'User 1, Question 3', 'User 3, Conetnt 3', '2012-03-26 02:43:36', '2012-03-26 02:43:36')")

# 问题答案
ActiveRecord::Base.connection.execute("INSERT INTO `answers` (`id`, `creator_id`, `question_id`, `content`, `vote_sum`, `created_at`, `updated_at`) VALUES
(1, 2, 1, 'answer 1 for question 1', NULL, NULL, NULL)")


# 家庭作业
ActiveRecord::Base.connection.execute("TRUNCATE TABLE homeworks")

Homework.create(:creator_id => 1, :title => 'user 1, homework 1', :content => 'content 1')
Homework.create(:creator_id => 1, :title => 'user 1, homework 2', :content => 'content 2')
Homework.create(:creator_id => 1, :title => 'user 1, homework 3', :content => 'content 3')

