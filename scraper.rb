# -*- coding: utf-8 -*-

require 'json'
require 'mechanize'
require 'turbotlib'

urls = {
  'Bank' => 'http://www.ropfic.org/approved-banks.html'
}

urls.each do |category, url|
  agent = Mechanize.new
  page = agent.get(url)
  page.search('#approved-banks').each do |bank|
    info = bank.search('#bank-info').text.split("\n").map {|s| s.strip}

    data = {
      company_name: bank.search('#bank-name img').attr('alt'),
      address: info[0, 2].join(', '),
      telephone: info[2].gsub('Tel: ', ''),
      fax: info[3].gsub('Fax: ', ''),
      url: info[4],
      category: category,
      source_url: url,
      sample_date: Time.now
    }

    puts JSON.dump(data)
  end
end
