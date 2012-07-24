require 'spec_helper'

describe Team do
  describe '#get_user_ids' do
    it_should_behave_like 'a academical organization form', :team, 4
  end
end
