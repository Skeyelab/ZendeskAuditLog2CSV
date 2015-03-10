require 'rubygems'
require 'bundler/setup'

require 'dotenv'
Dotenv.load


require 'typhoeus'
require 'pry'
require 'json'
require 'csv'

puts 

zendesk_domain = ENV['DOMAIN']
zendesk_user = ENV['USER']
zendesk_token = ENV['TOKEN']

CSV.open("out.csv", "wb") do |csv|


  for page in 1..10

    puts page

    response = Typhoeus.get("https://#{zendesk_domain}/api/v2/audit_logs.json?page=#{page}&sort_order=desc",
    userpwd: "#{zendesk_user}/token:#{zendesk_token}",
    headers: { ContentType: "application/json"})

    audits = JSON.parse(response.body)

    audits['audit_logs'].each_with_index do |audit_log,i|

      if page == 1 && i == 0
        csv << audit_log.keys
      end

      csv << audit_log.values
    end

  end

end
