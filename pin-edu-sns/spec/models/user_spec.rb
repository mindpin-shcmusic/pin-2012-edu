require 'spec_helper'

describe User do
  context 'access to user participating academical organizations' do
    it_should_behave_like 'user participated academical organization forms collection', :course
    it_should_behave_like 'user participated academical organization forms collection', :team
  end
end
