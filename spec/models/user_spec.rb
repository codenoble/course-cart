require 'spec_helper'

describe User do
  subject { User.new(first_name: 'Tobias', last_name: 'Funke') }

  its(:name) { should eql 'Tobias Funke' }
end