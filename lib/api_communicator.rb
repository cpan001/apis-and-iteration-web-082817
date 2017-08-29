require 'rest-client'
require 'json'
require 'pry'
require_relative './command_line_interface'



def api_request(urls)

    urls.inject([]){ |array, url|

        api_string = RestClient.get(url)

        final_url = JSON.parse(api_string)

        array << final_url

    }

end

def film_helper(character_hash, character)


    character_hash["results"].each { |char|
        return char['films'] if char["name"].downcase == character

    }

end


def get_character_movies_from_api(character)
  #make the web request
  all_characters = RestClient.get('http://www.swapi.co/api/people/')
  character_hash = JSON.parse(all_characters)

  # iterate over the character hash to find the collection of `films` for the given
  #   `character`

    char_movies = film_helper(character_hash, character)

    api_request(char_movies)

end


def parse_character_movies(films_hash)

    films_hash.each_with_index do |film, num|

        puts "#{num + 1} #{film["title"]}"

    end
end

def show_character_movies(character)
  films_hash = get_character_movies_from_api(character)
  parse_character_movies(films_hash)
end
