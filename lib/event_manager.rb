require 'csv'
require 'time'

def clean_number(homephone)
  homephone = homephone.gsub(/[^0-9]/, '')
  if homephone.length == 10
    homephone
  elsif homephone.length == 11 && homephone[0] == '1'
    homephone[1..10]
  else
    'Invalid phone number'
  end
end

def open_csv(csv_file)
  CSV.open(
    csv_file,
    headers: true,
    header_converters: :symbol
  )
end

def which_day(wday)
  case wday
  when 0
    'Sunday'
  when 1
    'Monday'
  when 2
    'Tuesday'
  when 3
    'Wednesday'
  when 4
    'Thursday'
  when 5
    'Friday'
  when 6
    'Saturday'
  end
end

def display_phone(csv_file)
  contents = open_csv(csv_file)
  contents.each do |row|
    name = row[:first_name]

    homephone = clean_number(row[:homephone])

    puts "#{name} #{homephone}"
  end

  puts ''
end

def tally_by_hour(csv_file)
  contents = open_csv(csv_file)

  reg_time = contents.map { |row| DateTime.strptime(row[:regdate], '%m/%d/%Y %k:%M').hour }.tally.sort_by { |_k, v| -v }

  reg_time.each do |row|
    puts "#{row[0]}:00-#{row[0]}:59 #{row[1]}"
  end

  puts ''
end

def tally_by_day(csv_file)
  contents = open_csv(csv_file)

  reg_day = contents.map { |row| DateTime.strptime(row[:regdate], '%m/%d/%Y %k:%M').wday }.tally.sort_by { |_k, v| -v }

  reg_day.each do |row|
    puts "#{which_day(row[0])} #{row[1]}"
  end
end



small_sample = 'event_attendees.csv'
large_sample = 'event_attendees_full.csv'

system 'clear'
puts "EventManager initialized.\n\n"

display_phone(small_sample)
tally_by_hour(large_sample)
tally_by_day(large_sample)
