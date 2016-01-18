require 'spec_helper'

describe User do
  subject { User.new(first_name: 'Tobias', last_name: 'Funke') }

  it { expect(subject.name).to eql 'Tobias Funke' }
end
