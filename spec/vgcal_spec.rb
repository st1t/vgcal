# frozen_string_literal: true

require 'vgcal/handlers/describer'
require 'vgcal/my_calendar'
require 'google/apis/core'
require 'googleauth'
require 'webmock'

Calendar = Google::Apis::CalendarV3

RSpec.describe Vgcal do
  it "has a version number" do
    expect(Vgcal::VERSION).not_to be nil
  end
end

RSpec.describe Vgcal::MyCalendar do
  it 'my_task' do
    start_date = '2021-07-25T00:00:00+09:00'
    end_date = '2021-07-25T23:59:59+09:00'
    mcal = Vgcal::MyCalendar.new(start_date, end_date)
    allow(mcal).to receive(:my_email_address).and_return('self@example.jp')

    events = Google::Apis::CalendarV3::Events.new
    events.items = []

    accepted_event_1 = Google::Apis::CalendarV3::Event.new
    accepted_event_1.summary = 'test_task1'
    accepted_event_1.status = 'accepted'
    accepted_event_1.organizer = Google::Apis::CalendarV3::Event::Organizer.new
    accepted_event_1.organizer.email = 'self@example.jp'
    accepted_event_1.start = Google::Apis::CalendarV3::EventDateTime.new
    accepted_event_1.start.date_time = DateTime.parse('2021-07-25T11:00:00+09:00')
    accepted_event_1.end = Google::Apis::CalendarV3::EventDateTime.new
    accepted_event_1.end.date_time = DateTime.parse('2021-07-25T12:00:00+09:00')
    events.items.push(accepted_event_1)

    accepted_event_2 = Google::Apis::CalendarV3::Event.new
    accepted_event_2.summary = 'test_task2'
    accepted_event_2.status = 'accepted'
    accepted_event_2.organizer = Google::Apis::CalendarV3::Event::Organizer.new
    accepted_event_2.organizer.email = 'self@example.jp'
    accepted_event_2.start = Google::Apis::CalendarV3::EventDateTime.new
    accepted_event_2.start.date_time = DateTime.parse('2021-07-25T13:00:00+09:00')
    accepted_event_2.end = Google::Apis::CalendarV3::EventDateTime.new
    accepted_event_2.end.date_time = DateTime.parse('2021-07-25T13:15:00+09:00')
    events.items.push(accepted_event_2)

    accepted_event_3 = Google::Apis::CalendarV3::Event.new
    accepted_event_3.summary = 'test_task2'
    accepted_event_3.status = 'accepted'
    accepted_event_3.organizer = Google::Apis::CalendarV3::Event::Organizer.new
    accepted_event_3.organizer.email = 'self@example.jp'
    accepted_event_3.start = Google::Apis::CalendarV3::EventDateTime.new
    accepted_event_3.start.date_time = DateTime.parse('2021-07-25T16:00:00+09:00')
    accepted_event_3.end = Google::Apis::CalendarV3::EventDateTime.new
    accepted_event_3.end.date_time = DateTime.parse('2021-07-25T16:15:00+09:00')
    events.items.push(accepted_event_3)

    expect(mcal.tasks(events)).to eq([1.5, [["test_task1", 1.0], ["test_task2", 0.5]]])
  end

  it 'my_task_hidden' do
    start_date = '2021-07-25T00:00:00+09:00'
    end_date = '2021-07-25T23:59:59+09:00'
    mcal = Vgcal::MyCalendar.new(start_date, end_date)
    allow(mcal).to receive(:my_email_address).and_return('self@example.jp')

    events = Google::Apis::CalendarV3::Events.new
    events.items = []

    accepted_event_1 = Google::Apis::CalendarV3::Event.new
    accepted_event_1.summary = '__test_task1'
    accepted_event_1.status = 'accepted'
    accepted_event_1.organizer = Google::Apis::CalendarV3::Event::Organizer.new
    accepted_event_1.organizer.email = 'self@example.jp'
    accepted_event_1.start = Google::Apis::CalendarV3::EventDateTime.new
    accepted_event_1.start.date_time = DateTime.parse('2021-07-25T11:00:00+09:00')
    accepted_event_1.end = Google::Apis::CalendarV3::EventDateTime.new
    accepted_event_1.end.date_time = DateTime.parse('2021-07-25T12:00:00+09:00')
    events.items.push(accepted_event_1)

    accepted_event_2 = Google::Apis::CalendarV3::Event.new
    accepted_event_2.summary = 'test_task2'
    accepted_event_2.status = 'accepted'
    accepted_event_2.organizer = Google::Apis::CalendarV3::Event::Organizer.new
    accepted_event_2.organizer.email = 'self@example.jp'
    accepted_event_2.start = Google::Apis::CalendarV3::EventDateTime.new
    accepted_event_2.start.date_time = DateTime.parse('2021-07-25T13:00:00+09:00')
    accepted_event_2.end = Google::Apis::CalendarV3::EventDateTime.new
    accepted_event_2.end.date_time = DateTime.parse('2021-07-25T13:15:00+09:00')
    events.items.push(accepted_event_2)

    accepted_event_3 = Google::Apis::CalendarV3::Event.new
    accepted_event_3.summary = 'test_task2'
    accepted_event_3.status = 'accepted'
    accepted_event_3.organizer = Google::Apis::CalendarV3::Event::Organizer.new
    accepted_event_3.organizer.email = 'self@example.jp'
    accepted_event_3.start = Google::Apis::CalendarV3::EventDateTime.new
    accepted_event_3.start.date_time = DateTime.parse('2021-07-25T16:00:00+09:00')
    accepted_event_3.end = Google::Apis::CalendarV3::EventDateTime.new
    accepted_event_3.end.date_time = DateTime.parse('2021-07-25T16:15:00+09:00')
    events.items.push(accepted_event_3)

    expect(mcal.tasks(events)).to eq([0.5, [["test_task2", 0.5]]])
  end

  it 'invitation_task' do
    start_date = '2021-07-25T00:00:00+09:00'
    end_date = '2021-07-25T23:59:59+09:00'
    mcal = Vgcal::MyCalendar.new(start_date, end_date)
    allow(mcal).to receive(:my_email_address).and_return('self@example.jp')

    events = Google::Apis::CalendarV3::Events.new
    events.items = []

    accepted_event_1 = Google::Apis::CalendarV3::Event.new
    accepted_event_1.summary = 'accepted_invitation_task1'
    accepted_event_1.status = 'confirmed'
    accepted_event_1.organizer = Google::Apis::CalendarV3::Event::Organizer.new
    accepted_event_1.organizer.email = 'organizer@example.jp'
    accepted_event_1.start = Google::Apis::CalendarV3::EventDateTime.new
    accepted_event_1.start.date_time = DateTime.parse('2021-07-25T11:00:00+09:00')
    accepted_event_1.end = Google::Apis::CalendarV3::EventDateTime.new
    accepted_event_1.end.date_time = DateTime.parse('2021-07-25T12:00:00+09:00')
    accepted_event_1.attendees = []
    attend1 = Google::Apis::CalendarV3::EventAttendee.new
    attend1.email = 'self@example.jp'
    attend1.response_status = 'accepted'
    attend1.self = true
    accepted_event_1.attendees.push(attend1)
    attend2 = Google::Apis::CalendarV3::EventAttendee.new
    attend2.email = 'not_counting@example.jp'
    attend2.response_status = 'accepted'
    accepted_event_1.attendees.push(attend2)
    events.items.push(accepted_event_1)

    accepted_event_2 = Google::Apis::CalendarV3::Event.new
    accepted_event_2.summary = 'accepted_invitation_task2'
    accepted_event_2.status = 'confirmed'
    accepted_event_2.organizer = Google::Apis::CalendarV3::Event::Organizer.new
    accepted_event_2.organizer.email = 'organizer@example.jp'
    accepted_event_2.start = Google::Apis::CalendarV3::EventDateTime.new
    accepted_event_2.start.date_time = DateTime.parse('2021-07-25T11:00:00+09:00')
    accepted_event_2.end = Google::Apis::CalendarV3::EventDateTime.new
    accepted_event_2.end.date_time = DateTime.parse('2021-07-25T12:00:00+09:00')
    accepted_event_2.attendees = []
    attend1 = Google::Apis::CalendarV3::EventAttendee.new
    attend1.email = 'self@example.jp'
    attend1.response_status = 'accepted'
    attend1.self = true
    accepted_event_2.attendees.push(attend1)
    attend2 = Google::Apis::CalendarV3::EventAttendee.new
    attend2.email = 'not_counting@example.jp'
    attend2.response_status = 'accepted'
    accepted_event_2.attendees.push(attend2)
    events.items.push(accepted_event_2)

    declined_event_1 = Google::Apis::CalendarV3::Event.new
    declined_event_1.summary = 'declined_invitation_task1'
    declined_event_1.status = 'confirmed'
    declined_event_1.organizer = Google::Apis::CalendarV3::Event::Organizer.new
    declined_event_1.organizer.email = 'organizer@example.jp'
    declined_event_1.start = Google::Apis::CalendarV3::EventDateTime.new
    declined_event_1.start.date_time = DateTime.parse('2021-07-25T11:00:00+09:00')
    declined_event_1.end = Google::Apis::CalendarV3::EventDateTime.new
    declined_event_1.end.date_time = DateTime.parse('2021-07-25T12:00:00+09:00')
    declined_event_1.attendees = []
    attend1 = Google::Apis::CalendarV3::EventAttendee.new
    attend1.email = 'self@example.jp'
    attend1.response_status = 'declined'
    attend1.self = true
    declined_event_1.attendees.push(attend1)
    attend2 = Google::Apis::CalendarV3::EventAttendee.new
    attend2.email = 'not_counting@example.jp'
    attend2.response_status = 'accepted'
    declined_event_1.attendees.push(attend2)
    events.items.push(declined_event_1)

    expect(mcal.invited_meetings(events)).to eq([2.0, [["accepted_invitation_task1", 1.0], ["accepted_invitation_task2", 1.0]]])
  end
end
