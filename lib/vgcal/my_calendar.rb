require 'vgcal/google/authorizer'

class MyCalendar

  def initialize(start_date, end_date)
    @start_date = start_date
    @end_date = end_date
  end

  def show
    events = calendar_events
    # 自身がオーナーになっているタスク一覧を表示
    tasks = my_tasks(events)
    puts "My tasks: #{tasks[0]}h(#{(tasks[0] / 8).round(2)}day)"
    tasks[1].each do |task|
      if task[1].kind_of?(String)
        puts "  ・#{task[0]}: #{task[1]}"
      else
        puts "  ・#{task[0]}: #{task[1]}h"
      end
    end
    puts
    # 招待されて出席にしているタスク一覧を表示
    meetings = invited_meetings(events)
    puts "Invited meetings: #{meetings[0]}h(#{(meetings[0] / 8).round(2)}day)"
    meetings[1].each do |meeting|
      puts "  ・#{meeting[0]}: #{meeting[1]}h"
    end
  end

  private

  def my_email_address
    "ito.shota@hamee.co.jp"
  end

  def application_name
    "Google Calendar API Ruby Quickstart"
  end

  def hide_words
    ["__"]
  end

  def all_day_event?(date)
    # The date, in the format "yyyy-mm-dd", if this is an all-day event.
    # https://developers.google.com/calendar/api/v3/reference/events
    !!/[0-9]...-[0-9].-[0-9]./.match(date.to_s)
  end

  # return: [4.25, [["daily scrum", 0.25], ["SRE定例", 1.0], ["test", 2.0], ["task2", 1.0]]]
  def my_tasks(events)
    total_meeting_times = 0
    tasks_hash = {}

    events.items.each do |e|
      if e.organizer.email.include?(my_email_address) && !e.summary.start_with?(*hide_words)
        if all_day_event?(e.start.date)
          tasks_hash[e.summary] = 'all day'
        else
          task_time = (e.end.date_time - e.start.date_time).to_f * 24
          # 1日の中で同じタスク名が複数あったら時間を集計する。例.午前と午後それぞれでAプロジェクトに1時間スケジュール
          if tasks_hash[e.summary]
            tasks_hash[e.summary] += task_time
          else
            tasks_hash[e.summary] = task_time
          end
          total_meeting_times = 0
          tasks_hash.each do |h|
            total_meeting_times += h.to_ary[1] unless h.to_ary[1].kind_of?(String)
          end
        end
      end
    end
    [total_meeting_times, tasks_hash.sort.to_a]
  end

  # return: [2.25, [["朝会", 0.5], ["daily scrum", 0.25], ["SRE朝会", 0.5], ["定例", 1.0]]]
  def invited_meetings(events)
    total_meeting_times = 0
    tasks_hash = {}

    events.items.each do |e|
      unless e.organizer.email.include?(my_email_address)
        e.attendees.each do |a|
          # response_status:
          #   accepted: 承諾
          #   tentative: 仮承諾
          #   declined: 欠席
          if a.email == my_email_address && a.response_status == 'accepted' # 自分が承諾したタスク
            unless e.summary.start_with?(*hide_words)
              task_time = (e.end.date_time - e.start.date_time).to_f * 24
              if tasks_hash[e.summary]
                tasks_hash[e.summary] += task_time
              else
                tasks_hash[e.summary] = task_time
              end

              total_meeting_times = 0
              tasks_hash.each do |h|
                total_meeting_times += h.to_ary[1]
              end
            end
          end
        end
      end
    end
    [total_meeting_times, tasks_hash.sort.to_a]
  end

  def calendar_events
    service = Google::Apis::CalendarV3::CalendarService.new
    service.client_options.application_name = application_name
    service.authorization = Vgcal::Authorizer.new.credentials
    calendar_id = "primary"
    service.list_events(calendar_id,
                        max_results: 100,
                        single_events: true,
                        order_by: "startTime",
                        time_min: @start_date,
                        time_max: @end_date)

  end
end
