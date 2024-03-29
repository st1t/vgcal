# frozen_string_literal: true

require 'vgcal/google/authorizer'
require 'dotenv'

# MyCalendar
module Vgcal
  class MyCalendar
    def initialize(start_date, end_date)
      @start_date = start_date
      @end_date = end_date
    end

    def events
      service = Google::Apis::CalendarV3::CalendarService.new
      service.authorization = Vgcal::Authorizer.new.credentials
      calendar_id = my_email_address
      service.list_events(
        calendar_id,
        max_results: 100,
        single_events: true,
        order_by: 'startTime',
        time_min: @start_date,
        time_max: @end_date
      )
    end

    # return: [["daily scrum", 0.25], ["SRE定例", 1.0], ["test", 2.0], ["task2", 1.0]]
    def tasks(events)
      tasks_hash = {}
      events.items.each do |e|
        if e.organizer&.self && !e.summary.start_with?(*hide_words)
          if all_day_event?(e.start.date)
            tasks_hash[e.summary] = 0
          else
            task_time = (e.end.date_time - e.start.date_time).to_f * 24
            # 1日の中で同じタスク名が複数あったら時間を集計する。例.午前と午後それぞれでAプロジェクトに1時間スケジュール
            if tasks_hash[e.summary]
              tasks_hash[e.summary] += task_time
            else
              tasks_hash[e.summary] = task_time
            end
          end
        end
      end
      tasks_hash.sort.to_a
    end

    # return: [["朝会", 0.5], ["daily scrum", 0.25], ["SRE朝会", 0.5], ["定例", 1.0]]
    def invited_meetings(events)
      tasks_hash = {}
      events.items.each do |e|
        next if valid_event?(e)

        # 単一のカレンダー内から自分が出席返答したイベントを探して計算
        e.attendees&.each do |a|
          next if valid_attendee?(a)

          add_task_time(tasks_hash, e)
        end
      end
      tasks_hash.sort.to_a
    end

    private

    def add_task_time(tasks_hash, event)
      task_time = (event.end.date_time - event.start.date_time).to_f * 24
      if tasks_hash[event.summary]
        tasks_hash[event.summary] += task_time
      else
        tasks_hash[event.summary] = task_time
      end
    end

    def valid_event?(event)
      event.organizer&.self || event.summary&.start_with?(*hide_words)
    end

    def valid_attendee?(attendee)
      return true if attendee.email != my_email_address
      return true if attendee.email == my_email_address && attendee.response_status != 'accepted'

      false
    end

    def my_email_address
      ENV.fetch('MY_EMAIL_ADDRESS')
    end

    def hide_words
      ['__']
    end

    def all_day_event?(date)
      # The date, in the format "yyyy-mm-dd", if this is an all-day event.
      # https://developers.google.com/calendar/api/v3/reference/events
      !!/[0-9]...-[0-9].-[0-9]./.match(date.to_s)
    end
  end
end
