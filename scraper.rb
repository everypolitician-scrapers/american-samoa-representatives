#!/bin/env ruby
# encoding: utf-8

require 'wikidata/fetcher'

members = EveryPolitician::Wikidata.morph_wikinames(source: 'tmtmtmtm/american-samoa-elections', column: 'wikiname')
EveryPolitician::Wikidata.scrape_wikidata(names: { en: members })
