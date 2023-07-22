# frozen_string_literal: true

module Vgcal
  # DateCalculator
  class DateCalculator
    def self.start_date(options)
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

    def self.end_date(options)
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
