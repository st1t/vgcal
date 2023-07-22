# frozen_string_literal: true

require 'vgcal/handlers/describer'
require 'vgcal/my_calendar'
require 'google/apis/core'
require 'googleauth'

Calendar = Google::Apis::CalendarV3

RSpec.describe Vgcal::MyCalendar do
  it 'my_task' do
    start_date = '2021-07-25T00:00:00+09:00'
    end_date = '2021-07-25T23:59:59+09:00'
    my_calendar = described_class.new(start_date, end_date)
    allow(my_calendar).to receive(:my_email_address).and_return('self@example.jp')

    events = Google::Apis::CalendarV3::Events.new
    events.items = []

    accepted_event1 = Google::Apis::CalendarV3::Event.new
    accepted_event1.summary = 'test_task1'
    accepted_event1.status = 'accepted'
    accepted_event1.organizer = Google::Apis::CalendarV3::Event::Organizer.new
    accepted_event1.organizer.email = 'self@example.jp'
    accepted_event1.organizer.self = true
    accepted_event1.start = Google::Apis::CalendarV3::EventDateTime.new
    accepted_event1.start.date_time = DateTime.parse('2021-07-25T11:00:00+09:00')
    accepted_event1.end = Google::Apis::CalendarV3::EventDateTime.new
    accepted_event1.end.date_time = DateTime.parse('2021-07-25T12:00:00+09:00')
    events.items.push(accepted_event1)

    accepted_event2 = Google::Apis::CalendarV3::Event.new
    accepted_event2.summary = 'test_task2'
    accepted_event2.status = 'accepted'
    accepted_event2.organizer = Google::Apis::CalendarV3::Event::Organizer.new
    accepted_event2.organizer.email = 'self@example.jp'
    accepted_event2.organizer.self = true
    accepted_event2.start = Google::Apis::CalendarV3::EventDateTime.new
    accepted_event2.start.date_time = DateTime.parse('2021-07-25T13:00:00+09:00')
    accepted_event2.end = Google::Apis::CalendarV3::EventDateTime.new
    accepted_event2.end.date_time = DateTime.parse('2021-07-25T13:15:00+09:00')
    events.items.push(accepted_event2)

    accepted_event3 = Google::Apis::CalendarV3::Event.new
    accepted_event3.summary = 'test_task2'
    accepted_event3.status = 'accepted'
    accepted_event3.organizer = Google::Apis::CalendarV3::Event::Organizer.new
    accepted_event3.organizer.email = 'self@example.jp'
    accepted_event3.organizer.self = true
    accepted_event3.start = Google::Apis::CalendarV3::EventDateTime.new
    accepted_event3.start.date_time = DateTime.parse('2021-07-25T16:00:00+09:00')
    accepted_event3.end = Google::Apis::CalendarV3::EventDateTime.new
    accepted_event3.end.date_time = DateTime.parse('2021-07-25T16:15:00+09:00')
    events.items.push(accepted_event3)

    expect(my_calendar.tasks(events)).to eq([['test_task1', 1.0], ['test_task2', 0.5]])
  end

  it 'my_task_hidden' do
    start_date = '2021-07-25T00:00:00+09:00'
    end_date = '2021-07-25T23:59:59+09:00'
    my_calendar = described_class.new(start_date, end_date)
    allow(my_calendar).to receive(:my_email_address).and_return('self@example.jp')

    events = Google::Apis::CalendarV3::Events.new
    events.items = []

    accepted_event1 = Google::Apis::CalendarV3::Event.new
    accepted_event1.summary = '__test_task1'
    accepted_event1.status = 'accepted'
    accepted_event1.organizer = Google::Apis::CalendarV3::Event::Organizer.new
    accepted_event1.organizer.email = 'self@example.jp'
    accepted_event1.organizer.self = true
    accepted_event1.start = Google::Apis::CalendarV3::EventDateTime.new
    accepted_event1.start.date_time = DateTime.parse('2021-07-25T11:00:00+09:00')
    accepted_event1.end = Google::Apis::CalendarV3::EventDateTime.new
    accepted_event1.end.date_time = DateTime.parse('2021-07-25T12:00:00+09:00')
    events.items.push(accepted_event1)

    accepted_event2 = Google::Apis::CalendarV3::Event.new
    accepted_event2.summary = 'test_task2'
    accepted_event2.status = 'accepted'
    accepted_event2.organizer = Google::Apis::CalendarV3::Event::Organizer.new
    accepted_event2.organizer.email = 'self@example.jp'
    accepted_event2.organizer.self = true
    accepted_event2.start = Google::Apis::CalendarV3::EventDateTime.new
    accepted_event2.start.date_time = DateTime.parse('2021-07-25T13:00:00+09:00')
    accepted_event2.end = Google::Apis::CalendarV3::EventDateTime.new
    accepted_event2.end.date_time = DateTime.parse('2021-07-25T13:15:00+09:00')
    events.items.push(accepted_event2)

    accepted_event3 = Google::Apis::CalendarV3::Event.new
    accepted_event3.summary = 'test_task2'
    accepted_event3.status = 'accepted'
    accepted_event3.organizer = Google::Apis::CalendarV3::Event::Organizer.new
    accepted_event3.organizer.email = 'self@example.jp'
    accepted_event3.organizer.self = true
    accepted_event3.start = Google::Apis::CalendarV3::EventDateTime.new
    accepted_event3.start.date_time = DateTime.parse('2021-07-25T16:00:00+09:00')
    accepted_event3.end = Google::Apis::CalendarV3::EventDateTime.new
    accepted_event3.end.date_time = DateTime.parse('2021-07-25T16:15:00+09:00')
    events.items.push(accepted_event3)

    expect(my_calendar.tasks(events)).to eq([['test_task2', 0.5]])
  end

  it 'invitation_task' do
    start_date = '2021-07-25T00:00:00+09:00'
    end_date = '2021-07-25T23:59:59+09:00'
    my_calendar = described_class.new(start_date, end_date)
    allow(my_calendar).to receive(:my_email_address).and_return('self@example.jp')

    events = Google::Apis::CalendarV3::Events.new
    events.items = []

    accepted_event1 = Google::Apis::CalendarV3::Event.new
    accepted_event1.summary = 'accepted_invitation_task1'
    accepted_event1.status = 'confirmed'
    accepted_event1.organizer = Google::Apis::CalendarV3::Event::Organizer.new
    accepted_event1.organizer.email = 'organizer@example.jp'
    accepted_event1.start = Google::Apis::CalendarV3::EventDateTime.new
    accepted_event1.start.date_time = DateTime.parse('2021-07-25T11:00:00+09:00')
    accepted_event1.end = Google::Apis::CalendarV3::EventDateTime.new
    accepted_event1.end.date_time = DateTime.parse('2021-07-25T12:00:00+09:00')
    accepted_event1.attendees = []
    attend1 = Google::Apis::CalendarV3::EventAttendee.new
    attend1.email = 'self@example.jp'
    attend1.response_status = 'accepted'
    attend1.self = true
    accepted_event1.attendees.push(attend1)
    attend2 = Google::Apis::CalendarV3::EventAttendee.new
    attend2.email = 'not_counting@example.jp'
    attend2.response_status = 'accepted'
    accepted_event1.attendees.push(attend2)
    events.items.push(accepted_event1)

    accepted_event2 = Google::Apis::CalendarV3::Event.new
    accepted_event2.summary = 'accepted_invitation_task2'
    accepted_event2.status = 'confirmed'
    accepted_event2.organizer = Google::Apis::CalendarV3::Event::Organizer.new
    accepted_event2.organizer.email = 'organizer@example.jp'
    accepted_event2.start = Google::Apis::CalendarV3::EventDateTime.new
    accepted_event2.start.date_time = DateTime.parse('2021-07-25T11:00:00+09:00')
    accepted_event2.end = Google::Apis::CalendarV3::EventDateTime.new
    accepted_event2.end.date_time = DateTime.parse('2021-07-25T12:00:00+09:00')
    accepted_event2.attendees = []
    attend1 = Google::Apis::CalendarV3::EventAttendee.new
    attend1.email = 'self@example.jp'
    attend1.response_status = 'accepted'
    attend1.self = true
    accepted_event2.attendees.push(attend1)
    attend2 = Google::Apis::CalendarV3::EventAttendee.new
    attend2.email = 'not_counting@example.jp'
    attend2.response_status = 'accepted'
    accepted_event2.attendees.push(attend2)
    events.items.push(accepted_event2)

    declined_event1 = Google::Apis::CalendarV3::Event.new
    declined_event1.summary = 'declined_invitation_task1'
    declined_event1.status = 'confirmed'
    declined_event1.organizer = Google::Apis::CalendarV3::Event::Organizer.new
    declined_event1.organizer.email = 'organizer@example.jp'
    declined_event1.start = Google::Apis::CalendarV3::EventDateTime.new
    declined_event1.start.date_time = DateTime.parse('2021-07-25T11:00:00+09:00')
    declined_event1.end = Google::Apis::CalendarV3::EventDateTime.new
    declined_event1.end.date_time = DateTime.parse('2021-07-25T12:00:00+09:00')
    declined_event1.attendees = []
    attend1 = Google::Apis::CalendarV3::EventAttendee.new
    attend1.email = 'self@example.jp'
    attend1.response_status = 'declined'
    attend1.self = true
    declined_event1.attendees.push(attend1)
    attend2 = Google::Apis::CalendarV3::EventAttendee.new
    attend2.email = 'not_counting@example.jp'
    attend2.response_status = 'accepted'
    declined_event1.attendees.push(attend2)
    events.items.push(declined_event1)

    expect(my_calendar.invited_meetings(events)).to eq([['accepted_invitation_task1', 1.0], ['accepted_invitation_task2', 1.0]])
  end
end
