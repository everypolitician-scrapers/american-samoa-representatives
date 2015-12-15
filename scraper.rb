#!/bin/env ruby
# encoding: utf-8

require 'json'
require 'pry'
require 'rest-client'
require 'scraperwiki'
require 'wikidata/fetcher'
require 'mediawiki_api'

def members
  morph_api_url = 'https://api.morph.io/tmtmtmtm/american-samoa-elections/data.json'
  morph_api_key = ENV["MORPH_API_KEY"]
  result = RestClient.get morph_api_url, params: {
    key: morph_api_key,
    query: "select DISTINCT(wikiname) as wikiname from data"
  }
  JSON.parse(result, symbolize_names: true)
end

WikiData.ids_from_pages('en', members.map { |c| c[:wikiname] }).each_with_index do |p, i|
  data = WikiData::Fetcher.new(id: p.last).data rescue nil
  unless data
    warn "No data for #{p}"
    next
  end
  data[:original_wikiname] = p.first
  ScraperWiki.save_sqlite([:id], data)
end


require 'rest-client'
warn RestClient.post ENV['MORPH_REBUILDER_URL'], {} if ENV['MORPH_REBUILDER_URL']

