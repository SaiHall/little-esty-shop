require 'rails_helper'

RSpec.describe HolidayFacade do
  it 'creates a holiday poros', :vcr do
    holiday = HolidayFacade.create_holiday
    expect(holiday[0]).to be_an_instance_of(Holiday)
  end
end
