require 'rest-client'
require 'json'
require 'pry'
require_relative './command_line_interface.rb'

def get_chars_array
  all_characters = RestClient.get('http://www.swapi.co/api/people/')
  character_hash = JSON.parse(all_characters)
  next_page = character_hash["next"]
  characters_array = character_hash["results"]

  while next_page
    new_all_characters = RestClient.get(next_page)
    new_character_hash = JSON.parse(new_all_characters)
    next_page = new_character_hash["next"]
    characters_array += new_character_hash["results"]
  end

  characters_array
end

def get_char_data(characters_array, character)
  characters_array.find { |char| char["name"].downcase == character.downcase}
end

def get_char_films(char_hash)
  char_hash["films"]
end

def get_film_info(film_arr)
  film_arr.inject([]) do |arr, url|
    film_info = RestClient.get(url)
    film_info_hash = JSON.parse(film_info)
    arr << film_info_hash
  end
end

def get_character_movies_from_api(character)
  chars_array = get_chars_array

  char_data = get_char_data(chars_array, character)

  until char_data
    puts "Not a valid character."
    character = get_character_from_user
    char_data = get_char_data(chars_array, character)
  end

  char_films = get_char_films(char_data)

  get_film_info(char_films)

end


def parse_character_movies(films_hash)
  # some iteration magic and puts out the movies in a nice list
  films_hash.each_with_index { |film, i|
    puts "#{i+1} #{film["title"]}"
  }
end

def show_character_movies(character)
  films_hash = get_character_movies_from_api(character)
  parse_character_movies(films_hash)
end

## BONUS

# that `get_character_movies_from_api` method is probably pretty long. Does it do more than one job?
# can you split it up into helper methods?
