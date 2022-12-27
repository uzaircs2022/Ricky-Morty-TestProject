# app/services/rickymorty_service.rb
class RickymortyService < ApplicationService
  
  require 'json'
  require 'rest-client'

  def initialize()
    @episode_url = 'https://rickandmortyapi.com/api/episode'
    @character_url = 'https://rickandmortyapi.com/api/character/'
  end

  def perform 
    prepare_episodes_array(@episode_url, @character_url, [])
  end

  private

  def prepare_episodes_array(episode_url, character_url, all_episodes)
    episodes = get_episodes(episode_url)
    character_objects = get_characters(episodes, character_url)
    all_episodes.concat(replace_characters(episodes, character_objects))

    if episodes['info']['next'].present?
      all_episodes = prepare_episodes_array(episodes['info']['next'],character_url ,all_episodes)
    end
    all_episodes
  end

  def replace_characters(episodes, characters)
    episodes['results'].each do |e|
      episode_cahracters = []
      e['characters'].each do |c|
        episode_cahracters.append(find_character(characters, c.split('/')[-1].to_i))
      end
      e['characters'] = episode_cahracters
    end
    episodes['results']
  end

  def find_character(characters, id)
    characters.each do |c|
      if c['id'] == id
        return c
      end
    end
  end

  def get_episode_characters(episodes)
    characters = []
    episodes.each do |e|
      characters.concat(get_character_ids(e['characters']))
    end

    characters.uniq.sort
  end

  def get_character_ids(characters)
    characters.map {|c| c.split('/')[-1].to_i }
  end

  def get_episodes(url)
    episodes = get(url)
    JSON.parse(episodes.body)
  end

  def get_characters(episodes, url)
    JSON.parse(get(url + get_episode_characters(episodes['results']).join(',')))
  end

  def get(url)
    RestClient.get(url)
  end
end