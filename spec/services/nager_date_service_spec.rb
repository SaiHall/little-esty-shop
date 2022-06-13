require "rails_helper"

RSpec.describe NagerService do
  describe 'API endpoint' do
    it 'can retrieve data from API endpoint', :vcr do
      json = NagerService.get_holiday_data
      expect(json[0]).to have_key(:name)
    end
  end
end
