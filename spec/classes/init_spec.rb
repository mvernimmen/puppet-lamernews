require 'spec_helper'
describe 'lamernews' do

  context 'with defaults for all parameters' do
    it { should contain_class('lamernews') }
  end
end
