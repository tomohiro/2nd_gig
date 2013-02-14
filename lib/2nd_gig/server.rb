#!/usr/bin/env ruby
# encoding: utf-8
# Inspired by https://github.com/cho45/net-irc/blob/master/examples/gig.rb

require 'time'
require 'open-uri'
require 'net/irc'
require 'nokogiri'

module SecondGig
  class GitHubIrcGateway < Net::IRC::Server::Session
    EVENTS = {
      DownloadEvent: 6,
      GistEvent:     60,
      WatchEvent:    15,
      FollowEvent:   15,
      CreateEvent:   13,
      ForkEvent:     3,
      PushEvent:     14,
    }

    def server_name
      :github
    end

    def server_version
      SecondGig::VERSION
    end

    def main_channel
      @opts.main_channel || '#github'
    end

    def initialize(*args)
      super
      @public_timeline = {
        channel: '#public',
        uri:     'https://github.com/timeline.atom'
      }
      @last_monitored = { @public_timeline[:channel] => Time.now, main_channel => Time.now }
    end

    def on_disconnected
      @monitor_thread.kill rescue nil
    end

    def on_join(message)
      channel_name = message.params.first
      post(@nick, JOIN, channel_name)
    end

    def on_user(message)
      super
      post(@nick, JOIN, main_channel)

      uri = "https://github.com/#{@real}.private.atom?token=#{@pass}"
      @monitor_thread = Thread.start do
        loop do
          @log.info('monitoring feeds...')
          monitoring(main_channel, uri)
          monitoring(@public_timeline[:channel], @public_timeline[:uri])
          @log.info('sleep 60 seconds')
          sleep 60
        end
      end
    end

    private
      def monitoring(channel, uri)
        events = parse_event_feed(uri)
        events.reverse_each do |event|
          next if event[:datetime] <= @last_monitored[channel]
          type = event[:id][/\d+:(.+)\//, 1].to_sym
          privmsg(event[:author], channel, "\003#{EVENTS[type] || '5'}#{event[:title]}\017 \00314#{event[:link]}\017")
        end
        @last_monitored[channel] = events.first[:datetime]
      rescue Exception => e
        @log.error(e.inspect)
        e.backtrace.each { |l| @log.error "\t#{l}" }
        sleep 300
      end

      def parse_event_feed(uri)
        Nokogiri::XML(open(uri)).search('entry').map do |event|
          {
            id:       event.at('id').text,
            title:    event.at('title').text,
            author:   event.at('author/name').text,
            link:     event.at('link').attributes['href'].text,
            datetime: Time.parse(event.at('published').text)
          }
        end
      end

      def privmsg(nick, channel, message)
        post(nick, PRIVMSG, channel, message)
      end
  end
end
