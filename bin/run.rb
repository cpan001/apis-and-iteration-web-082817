#!/usr/bin/env ruby

require_relative "../lib/api_communicator.rb"
require_relative "../lib/command_line_interface.rb"

welcome

#iterate over this process for each page of the api

character = get_character_from_user
show_character_movies(character)
