# frozen_string_literal: true

require 'thor'
require 'vgcal/my_calendar'
require 'fileutils'

module Vgcal
  module Handlers
    # Describer
    class Describer < Thor
      desc 'init', 'Make directory and template credentials.json for Google authentication'

      def init
        vgcal_dir = "#{Dir.home}/.vgcal"
        cred_json = "#{vgcal_dir}/credentials.json"
        dot_env = "#{vgcal_dir}/.env"
        Dir.mkdir(vgcal_dir, 0o755) unless Dir.exist?(vgcal_dir)
        FileUtils.cp('template-credentials.json', cred_json) unless File.exist?(cred_json)
        FileUtils.cp('template.env', dot_env) unless File.exist?(dot_env)
        puts "Fix the __FIX_ME__ in #{cred_json} and #{dot_env}"
      end

      option :date, type: :string, aliases: '-d', desc: 'Show relative date. ex.-1, +10'
      option :'current-week', type: :string, aliases: '-c', desc: 'Show current week tasks'
      option :'start-date', type: :numeric, aliases: '-s', desc: 'Start date. ex.20210701'
      option :'end-date', type: :numeric, aliases: '-e', desc: 'End date. ex.20210728'

      desc 'show', 'Show google calendar'

      def show
        Dotenv.load("#{Dir.home}/.vgcal/.env")
        puts "Period: #{start_date} - #{end_date}"
        puts
        mcal = MyCalendar.new(start_date, end_date)
        events = mcal.events
        tasks = mcal.tasks(events)
        puts "My tasks: #{tasks[0]}h(#{(tasks[0] / 8).round(2)}day)"
        tasks[1].each do |task|
          if task[1].is_a?(String)
            puts "  ・#{task[0]}: #{task[1]}"
          else
            puts "  ・#{task[0]}: #{task[1]}h"
          end
        end
        meetings = mcal.invited_meetings(events)
        puts "Invited meetings: #{meetings[0]}h(#{(meetings[0] / 8).round(2)}day)"
        meetings[1].each do |meeting|
          puts "  ・#{meeting[0]}: #{meeting[1]}h"
        end
      end

      desc 'version', 'View vgcal version'

      def version
        puts VERSION
      end

      private

      def start_date
        s_date = if options[:'current-week']
                   if Date.today.sunday?
                     Date.today.to_s
                   else
                     (Date.today - Date.today.wday - 1).to_s
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
                   Date.parse(options['start-date']).to_s
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
                   Date.parse(options['end-date']).to_s
                 else
                   Date.today.to_s
                 end
        "#{e_date}T23:59:59+09:00"
      end
    end
  end
end

Vgcal::Handlers::Describer.start(ARGV)
