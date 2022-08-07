# frozen_string_literal: true

require 'vgcal/handlers/describer'
require 'vgcal/my_calendar'
require 'google/apis/core'
require 'googleauth'

Calendar = Google::Apis::CalendarV3

RSpec.describe Vgcal do
  it "has a version number" do
    expect(Vgcal::VERSION).not_to be_nil
  end
end
