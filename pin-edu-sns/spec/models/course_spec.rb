require 'spec_helper'

describe Course do
  describe '#get_user_ids' do
    it_should_behave_like 'a academical organization form', :course, 4
  end
end
