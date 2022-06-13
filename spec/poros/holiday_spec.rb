require 'rails_helper'

RSpec.describe Holiday do
  it 'exists and has attributes' do
    data = { name: "Bear Day" }
    holiday = Holiday.new(data)

    expect(holiday).to be_an_instance_of(Holiday)
    expect(holiday.name).to eq(data[:name])    
  end
end
