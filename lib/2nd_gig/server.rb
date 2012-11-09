#!/usr/bin/env ruby
# encoding: utf-8
# Inspired by https://github.com/cho45/net-irc/blob/master/examples/gig.rb

require 'logger'
require 'ostruct'
require 'time'
require 'open-uri'
require 'rubygems'
require 'net/irc'
require 'nokogiri'

module SecondGig
  class GitHubIrcGateway < Net::IRC::Server::Session
    EVENTS = {
      'DownloadEvent' => '6',
      'GistEvent'     => '60',
      'WatchEvent'    => '15',
      'FollowEvent'   => '15',
      'CreateEvent'   => '13',
      'ForkEvent'     => '3',
      'PushEvent'     => '14',
    }

    def server_name
      'github'
    end

    def server_version
      SecondGig::VERSION
    end

    def main_channel
      @opts.main_channel || '#github'
    end

    def initialize(*args)
      super
      @last_retrieved = Time.now
    end

    def on_disconnected
      @retrieve_thread.kill rescue nil
    end

    def on_user(m)
      super
      post @nick, JOIN, main_channel

      @retrieve_thread = Thread.start do
        loop do
          begin
            events = []
            @log.info 'retrieveing feed...'
            uri = "https://github.com/#{@real}.private.atom?token=#{@pass}"
            Nokogiri::XML(open(uri)).search('entry').each do |event|
              events << {
                :id       => event.at('id').text,
                :title    => event.at('title').text,
                :author   => event.at('author/name').text,
                :link     => event.at('link').attributes['href'].text,
                :datetime => Time.parse(event.at('published').text)
              }
            end

            events.reverse_each do |event|
              next if event[:datetime] <= @last_retrieved
              type = event[:id][/\d+:(.+)\//, 1]
              post event[:author], PRIVMSG, main_channel,
                "\003#{EVENTS[type] || '5'}#{event[:title]}\017 \00314#{event[:link]}\017"
            end

            @last_retrieved = events.first[:datetime]
            @log.info 'sleep'
            sleep 60
          rescue Exception => e
            @log.error e.inspect
            e.backtrace.each do |l|
              @log.error "\t#{l}"
            end
            sleep 60
          end
        end
      end
    end
  end
end
