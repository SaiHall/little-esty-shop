class HolidayFacade

  def self.rate_limit_error_backup
    json = NagerService.get_holiday_data
    json[0][:message].nil? ? create_holiday : json
  end

  def self.create_holiday
    json = NagerService.get_holiday_data
    json[0..2].map { |data| Holiday.new(data) }
  end
end
