require 'rest-client'
require 'json'
require 'pry'
require_relative './command_line_interface'

def api_request(urls)

    urls.inject([]) { |array, url|

        api_string = RestClient.get(url)

        final_url = JSON.parse(api_string)

        array << final_url

    }

end

#

def get_char_movie_urls(character_hash, character)
    until (character_hash["results"].find { |c| c["name"].downcase == character.downcase})
      puts "Not a valid character"
      character = get_character_from_user
    end
    character_hash["results"].each { |char|
    return char["films"] if char["name"].downcase == character.downcase
    }
end

#------------------------------------------------------



def get_character_movies_from_api(character)

    all_characters = RestClient.get('http://www.swapi.co/api/people/')
    character_hash = JSON.parse(all_characters)

    page = 2
    while page < 10
        all_characters = RestClient.get("http://www.swapi.co/api/people/?page=#{page}")
        new_characters = JSON.parse(all_characters)["results"]
        character_hash["results"] += new_characters
        page += 1
    end
    char_movies = film_helper(character_hash, character)
    api_request(char_movies)
end

#

def film_helper(character_hash, character)

    until (character_hash["results"].find { |c| c["name"].downcase == character.downcase})
        puts "Not a valid character"
        character = get_character_from_user
    end
        character_hash["results"].each { |char|
        return char["films"] if char["name"].downcase == character.downcase
    }

end

#

def parse_character_movies(films_hash)

    films_hash.each_with_index do |film, num|

        puts "#{num + 1} #{film["title"]}"

    end
end

#

def show_character_movies(character)

  films_hash = get_character_movies_from_api(character)

  parse_character_movies(films_hash)

end
