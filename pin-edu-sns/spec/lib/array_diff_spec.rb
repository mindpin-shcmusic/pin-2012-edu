require 'spec_helper'

describe ArrayDiff do
  let(:old)          {[1, 2, 3, 4, 7]}
  let(:new)          {[4, 5, 6, 2, 8]}
  let(:intersection) {(old & new).sort}
  let(:union)        {(old | new).sort}
  let(:deleted)      {(old - new).sort}
  let(:added)        {(new - old).sort}
  let(:merge)        {(intersection + added).sort}

  context 'instance methods' do
    subject {ArrayDiff.new :old => old, :new => new}

    [:added, :deleted, :union, :intersection, :merge].each do |method_name|
      describe "##{method_name}" do
        its(method_name) {should eq send(method_name)}
      end
    end

  end

  context 'class methods' do
    [:added, :deleted, :union, :intersection, :merge].each do |method_name|
      describe "::#{method_name}" do
        subject {ArrayDiff.send(method_name, old, new)}
        it {should eq send(method_name)}
      end
    end

  end

end
