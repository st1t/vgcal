require 'thor'
require 'vgcal/my_calendar'
require 'fileutils'

module Vgcal
  module Handlers
    class Describer < Thor
      desc 'init', 'Make directory and template credentials.json for Google authentication'

      def init
        vgcal_dir = "#{Dir.home}/.vgcal"
        cred_json = "#{vgcal_dir}/credentials.json"
        Dir.mkdir("#{vgcal_dir}",0755) unless Dir.exist?("#{vgcal_dir}")
        FileUtils.cp('template-credentials.json',"#{cred_json}") unless File.exist?(cred_json)
        puts "Fix the __FIX_ME__ in #{cred_json}"
      end

      option :date, type: :string, aliases: '-d', desc: 'Show relative date. ex.-1, +10'
      option :'current-week', type: :string, aliases: '-c', desc: 'Show current week tasks'
      option :'start-date', type: :numeric, aliases: '-s', desc: 'Start date. ex.20210701'
      option :'end-date', type: :numeric, aliases: '-e', desc: 'End date. ex.20210728'

      desc 'show', 'Show google calendar'

      def show
        puts "Period: #{start_date} - #{end_date}"
        puts
        mcal = MyCalendar.new(start_date, end_date)
        mcal.show
      end

      desc 'version', 'View vgcal version'

      def version
        puts VERSION
      end

      private

      def start_date
        if options[:'current-week']
          if Date.today.sunday?
            s_date = Date.today.to_s
          else
            s_date = ((Date.today - Date.today.wday - 1).to_s).to_s
          end
        elsif options[:date]
          case options[:date][0]
          when '+'
            s_date = (Date.today + options[:date].delete('+').to_i).to_s
          when '-'
            s_date = (Date.today - options[:date].delete('-').to_i).to_s
          else
            s_date = (Date.today + options[:date].to_i).to_s
          end
        elsif options['start-date'] && options['end-date']
          s_date = Date.parse(options['start-date']).to_s
        else
          s_date = (Date.today.to_s).to_s
        end
        s_date + "T00:00:00+09:00"
      end

      def end_date
        if options[:'current-week']
          if Date.today.sunday?
            e_date = Date.today.to_s + 6
          else
            e_date = ((Date.today + (6 - Date.today.wday)).to_s).to_s
          end
        elsif options[:date]
          case options[:date][0]
          when '+'
            e_date = (Date.today + options[:date].delete('+').to_i).to_s
          when '-'
            e_date = (Date.today - options[:date].delete('-').to_i).to_s
          else
            e_date = (Date.today + options[:date].to_i).to_s
          end
        elsif options['start-date'] && options['end-date']
          e_date = Date.parse(options['end-date']).to_s
        else
          e_date = (Date.today.to_s).to_s
        end
        e_date + "T23:59:59+09:00"
      end
    end
  end
end

Vgcal::Handlers::Describer.start(ARGV)
