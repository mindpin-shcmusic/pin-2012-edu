require 'spec_helper'

describe User do

  let(:zhang) {FactoryGirl.create :user}
  let(:wang)  {FactoryGirl.create :user}
  let(:li)    {FactoryGirl.create :user}
  let(:zhao)  {FactoryGirl.create :user}

  describe '用户可以设定角色' do
    zhang.set_role :admin
    zhang.role?(:admin).should == true

    zhang.set_role :teacher
    zhang.role?(:teacher).should == true
    zhang.role?(:admin).should == false

    zhang.is_teacher?.should == true
    zhang.is_admin?.should == false
  end

  describe '可以查询不同角色的用户' do

    5.times do
      FactoryGirl.create :user, :teacher
    end

    6.times do
      FactoryGirl.create :user, :student
    end

    1.times do
      FactoryGirl.create :user, :admin
    end

    User.with_role(:teacher).count.should == 5
    User.with_role(:student).count.should == 6
    User.with_role(:admin).count.should == 1
  end
end