require "yaml"
require_relative 'scraper'

puts "Please input how many movies you want to scrape:"
number = gets.chomp.to_i

puts "Fetching your movies"
movie_urls = fetch_movie_urls(number)

puts "Movies were fetched!"

movies = []

puts "Scraping your movies"
counter = 1

movie_urls.each do |movie_url|
  movie = scrape_movie(movie_url)
  movies << movie
  puts "#{counter} - #{movie[:title]}"
  counter += 1
end

puts "Write to the YAML"

File.open("the_file.yml", "w") do |f|
  f.write(movies.to_yaml)
end

puts "YAML is written"
