require 'open-uri'
require 'nokogiri'

# TIP: to open in english
# open(url, "Accept-Language" => "en")
def fetch_movie_urls(number = 5)
  url = "https://www.imdb.com/chart/top"

  html_file = open(url, "Accept-Language" => "en").read
  html_doc = Nokogiri::HTML(html_file)

  movies = []
  html_doc.search('.lister-list tr td.titleColumn a').first(number).each do |element|
    movies << "http://www.imdb.com#{element.attribute('href').value}"
  end
  movies
end

def find_cast(html_doc)
  # This is the same as the one below
  # html_doc.search(".primary_photo + td a").first(3).map do |element|
  #   element.text.strip
  # end

  array = []
  html_doc.search(".primary_photo + td a").first(3).each do |element|
    array << element.text.strip
  end
  array
end

def find_director(html_doc)
  html_doc.search("h4:contains('Director:') + a").text
end

def find_storyline(html_doc)
  html_doc.search(".summary_text").text.strip
end

def find_title(html_doc)
  # html_doc.search("h1").text is
  # "The Godfather (1972)"
  html_doc.search("h1").text.match(/^(?<title>.+)[[:space:]]\((?<year>\d+)\)/)[:title]
end

def find_year(html_doc)
  html_doc.search("h1").text.match(/^(?<title>.+)[[:space:]]\((?<year>\d+)\)/)[:year].to_i
end

def scrape_movie(movie_url)
  html_file = open(movie_url, "Accept-Language" => "en").read
  html_doc = Nokogiri::HTML(html_file)

  {
    cast: find_cast(html_doc),
    director: find_director(html_doc),
    storyline: find_storyline(html_doc),
    title: find_title(html_doc),
    year: find_year(html_doc)
  }
end

# you can just test it here
# p scrape_movie('https://www.imdb.com/title/tt0381707/')
