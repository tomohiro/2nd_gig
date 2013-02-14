#!/usr/bin/env ruby
# encoding: utf-8
# Fork of https://github.com/cho45/net-irc/blob/master/examples/gig.rb

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

    CHANNELS = {
      news_feed:    { channel: '#github', uri: 'https://github.com/%s.private.atom?token=%s' },
      public_feed:  { channel: '#public', uri: 'https://github.com/timeline.atom' },
      private_feed: { channel: '#private', uri: 'https://github.com/%s.private.actor.atom?token=%s' }
    }

    def server_name
      :github
    end

    def server_version
      SecondGig::VERSION
    end

    def initialize(*args)
      super
      @last_monitored  = {}
      @monitor_threads = {}
    end

    def main_channel
      CHANNELS[:news_feed]
    end

    def on_user(message)
      super

      channel = main_channel[:channel]
      uri     = main_channel[:uri]
      post(@nick, JOIN, channel)
      @last_monitored[channel] = Time.now
      @monitor_threads[channel] = start_monitoring(channel, uri)
    end

    def on_join(message)
      super
      channel_name = message.params.first
      post(@nick, JOIN, channel_name)

      if channel = get_channel_information(channel_name)
        @monitor_threads[channel_name] = start_monitoring(channel_name, channel[:uri])
      end
    end

    def on_part(message)
      channel_name = message.params.first
      post(@nick, PART, channel_name)

      if @monitor_threads.fetch(channel_name, false)
        @monitor_threads[channel].kill
      end
    end

    def on_disconnected
      @monitor_threads.each do |channel, thread|
        @log.info("#{channel} thread kill...")
        thread.kill
      end
    end

    private
      def start_monitoring(channel, uri)
        @last_monitored[channel] = Time.now
        Thread.start do
          loop do
            begin
              @log.info("#{channel} monitoring feeds...")

              events = parse_event_feed(uri % [@real, @pass])
              events.reverse_each do |event|
                next if event[:datetime] <= @last_monitored[channel]
                type = event[:id][/\d+:(.+)\//, 1].to_sym
                privmsg(event[:author], channel, "\003#{EVENTS[type] || '5'}#{event[:title]}\017 \00314#{event[:link]}\017")
              end

              @last_monitored[channel] = events.first[:datetime]
              @log.info("#{channel} sleep 60 seconds")
              sleep 60
            rescue Exception => e
              @log.error(e.inspect)
              e.backtrace.each { |l| @log.error "\t#{l}" }
              sleep 300
            end
          end
        end
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

      def get_channel_information(channel)
        CHANNELS.each_value do |channel_info|
          return channel_info if channel_info[:channel] == channel
        end
        false
      end
  end
end
