module VoteHelper
  
  # 根据限选数目限制返回描述字符串
  def vote_select_limit_desc(vote)
    return '单选' if 1 == vote.select_limit
    return "限选#{vote.select_limit}项"
  end
  
  # 根据参与人数返回描述字符串
  def voted_users_count_str(vote)
    count = vote.voted_users.count
    count == 0 ? '还没有人参与' : "#{count}人参与"
  end
  
end