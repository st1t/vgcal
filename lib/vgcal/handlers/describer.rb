# frozen_string_literal: true

require 'thor'
require 'vgcal/my_calendar'
require 'fileutils'
require 'json'

module Vgcal
  module Handlers
    # Describer
    class Describer < Thor
      desc 'init', 'Make directory and template credentials.json for Google authentication'

      def init
        vgcal_dir = "#{Dir.home}/.vgcal"
        cred_json = "#{vgcal_dir}/credentials.json"
        dot_env   = "#{vgcal_dir}/.env"
        gem_root  = File.expand_path '../../../', __dir__
        FileUtils.mkdir_p(vgcal_dir, mode: 0o755)
        FileUtils.cp(File.join(gem_root,'template-credentials.json'), cred_json) unless File.exist?(cred_json)
        FileUtils.cp(File.join(gem_root,'template.env'), dot_env) unless File.exist?(dot_env)
        puts "Fix the __FIX_ME__ in #{cred_json} and #{dot_env}"
      end

      option :date, type: :string, aliases: '-d', desc: 'Show relative date. ex.-1, +10'
      option :'current-week', type: :boolean, aliases: '-c', desc: 'Show current week tasks'
      option :'next-week', type: :boolean, aliases: '-n', desc: 'Show next week tasks'
      option :'start-date', type: :numeric, aliases: '-s', desc: 'Start date. ex.20210701'
      option :'end-date', type: :numeric, aliases: '-e', desc: 'End date. ex.20210728'
      option :output, type: :string, aliases: '-o', desc: 'Output format. [text|json]'

      desc 'show', 'Show google calendar'

      def show
        Dotenv.load("#{Dir.home}/.vgcal/.env")
        mcal   = MyCalendar.new(start_date, end_date)
        events = mcal.events

        case options[:output]
        when 'json'
          stdout_json(mcal.tasks(events), mcal.invited_meetings(events))
        when 'text', 'output', nil
          stdout_default(mcal.tasks(events), mcal.invited_meetings(events))
        end
      end

      desc 'version', 'View vgcal version'

      def version
        puts VERSION
      end

      private

      def stdout_json(my_tasks, invited_meetings)
        hash = {
          start_date: "#{start_date}",
          end_date:   "#{end_date}",
          tasks:      []
        }
        my_tasks.each do |task|
          hash[:tasks].push ({
            title:     task[0],
            time:      task[1],
            task_type: 'my_task'
          })
        end
        invited_meetings.each do |meeting|
          hash[:tasks].push ({
            title:     meeting[0],
            time:      meeting[1],
            task_type: 'invited_meeting'
          })
        end
        puts hash.to_json
      end

      def stdout_default(my_tasks, invited_meetings)
        puts "Period: #{start_date} - #{end_date}"
        puts
        my_task_time = 0
        my_tasks.select do |n|
          my_task_time += n[1]
        end
        puts "My tasks: #{my_task_time}h(#{(my_task_time / 8).round(2)}day)"
        my_tasks.each do |task|
          if my_tasks.is_a?(String)
            puts "  ・#{task[0]}: #{task[1]}"
          else
            puts "  ・#{task[0]}: #{task[1]}h"
          end
        end

        meeting_time = 0
        invited_meetings.select do |m|
          meeting_time += m[1]
        end
        puts "Invited meetings: #{meeting_time}h(#{(meeting_time / 8).round(2)}day)"
        invited_meetings.each do |meeting|
          puts "  ・#{meeting[0]}: #{meeting[1]}h"
        end
      end

      def start_date
        s_date = if options[:'current-week']
                   if Date.today.sunday?
                     Date.today.to_s
                   else
                     (Date.today - Date.today.wday).to_s
                   end
                 elsif options[:'next-week']
                   if Date.today.sunday?
                     (Date.today + 7).to_s
                   else
                     (Date.today + Date.today.wday - 1).to_s
                   end
                 elsif options[:date]
                   case options[:date][0]
                   when '+'
                     (Date.today + options[:date].delete('+').to_i).to_s
                   when '-'
                     (Date.today - options[:date].delete('-').to_i).to_s
                   else
                     (Date.today + options[:date].to_i).to_s
                   end
                 elsif options['start-date'] && options['end-date']
                   Date.parse(options['start-date'].to_s)
                 else
                   Date.today.to_s
                 end
        "#{s_date}T00:00:00+09:00"
      end

      def end_date
        e_date = if options[:'current-week']
                   if Date.today.sunday?
                     (Date.today + 6).to_s
                   else
                     (Date.today + (6 - Date.today.wday)).to_s
                   end
                 elsif options[:'next-week']
                   if Date.today.sunday?
                     (Date.today + 13).to_s
                   else
                     (Date.today + 7 + (6 - Date.today.wday)).to_s
                   end
                 elsif options[:date]
                   case options[:date][0]
                   when '+'
                     (Date.today + options[:date].delete('+').to_i).to_s
                   when '-'
                     (Date.today - options[:date].delete('-').to_i).to_s
                   else
                     (Date.today + options[:date].to_i).to_s
                   end
                 elsif options['start-date'] && options['end-date']
                   Date.parse(options['end-date'].to_s)
                 else
                   Date.today.to_s
                 end
        "#{e_date}T23:59:59+09:00"
      end
    end
  end
end

Vgcal::Handlers::Describer.start(ARGV)
