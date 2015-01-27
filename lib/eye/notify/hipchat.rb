require 'eye'
require 'eye/notify/hipchat/version'

require 'hipchat'

module Eye
  class Notify

    class Hipchat < Eye::Notify::Custom

      # Eye.config do
      #   hipchat token: '1312312', api: 'v1', name: 'eye bot', color: 'red'
      #   contact :info, :hipchat, 'room name'
      # end

      param :token, String, true
      # not required, if not specified, we're using v1
      param :api, String, false, 'v1'
      # not required, if not specified, we're using 'Eye Bot'
      param :name, String, false, 'Eye Bot'
      # not required, 'yellow' as default color
      param :color, String, false, 'yellow', ['gray','green','purple','red','yellow','random']
      # available messages:
      #  time host message name full_name pid level
      param :message, String, false, '<strong>#name#</strong> on #host# #message# at #time#.'

      def execute
        say(parse_message)
      end

      private

      def parse_message
        %w{time host message name full_name pid level}.each do |variable|
          message.gsub!("##{variable}#", send("msg_#{variable}").to_s) if message =~ /##{variable}#/
        end
        message
      end

      def msg_time
        Eye::Utils.human_time2(msg_at)
      end

      def client
        HipChat::Client.new(token, api_version: api)
      end

      def say(what)
        client[contact].send(name, what, message_format: 'html')
      end
    end

  end
end