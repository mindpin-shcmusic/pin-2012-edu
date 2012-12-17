module DashboardHelper

  def get_dashboard_arr(arr)
    re = []
    0.upto 3 do |i|
      re << arr[i]
    end
    return re
  end

end