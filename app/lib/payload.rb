require 'json'
require 'multi_json'

module CRX
  module Payload

    def call_handler
      dd = parse_method
      @cmd = dd.first
      @var = dd.last
      puts @cmd
      puts @var
      !@var.nil? ? send(@cmd.to_sym, @var) : send(@cmd.to_sym)
    end

    def call_chat_handler
      dd = parse_chat_method
      @cmd = dd.first
      @var = dd.last
      !@var.nil? ? send(@cmd.to_sym, @var) : send(@cmd.to_sym)
    end

    def parse_update(body)
      bdy = json_load(body)
      @update = Telegram::Bot::Types::Update.new(bdy)
      @payload = extract_message(@update)
      @update_id = @update.update_id
    end

    def log_update
      l = "[#{@tsx_bot.id}]#{@tsx_bot.tele}".black.on_yellow
      p = "#{hb_client.id}/#{hb_client.username}, #{@cmd}, variable: #{@var.nil? ? 'n/a' : @var}".colorize(:blue)
      puts l << " " << p
      # blue "chat ##{chat}, update ##{@update_id}, message ##{message_id}"
      # blue "#{YAML.load(@hb_sessa.data).to_hash}"
      # deb @tsx_bot.inspect
      # lg "user: [#{hb_client.id}] #{hb_client.username}"
      # lg "from: @#{from}"
      # lg "chat: #{chat}"
      # lg "message/callback id: #{message_id}"
      # lg "message to edit: #{has_editable?}"
      # lg "action: #{type}"
      # lg "handler: #{@cmd}"
      # lg "variable: #{@var.nil? ? 'n/a' : $var}"
      # lg "session for #{chat}: #{session.inspect}"
      # lg "--"
    end

    def message_id
      if callback_query?
        @payload.message.message_id
      else
        @payload.message_id
      end
    end

    def chat
      callback_query? ? @payload.message.chat.id : @payload.chat.id
    end

    def group_title
      @payload.chat.title
    end

    def callback_query?
      type == 'callbackquery'
    end

    def message?
      type == 'message'
    end

    def location?
      @payload.location.nil? ? false : @payload.location
    end

    def file?
      if !@payload.photo.nil?
        if @payload.photo.last
          @payload.photo.last.file_id
        else
          false
        end
      else
        false
      end
    end

    def from
      @payload.from.username.nil? ? @payload.from.id : @payload.from.username
    end

    def type
      @payload.class.name.split('::').last.downcase
    end

    def clear_text
      if @payload.text
        @payload.text.gsub('/', '').split(' ').last
      end
    end

    def clear_data
      if @payload.data
        @payload.data
      end
    end

    def hardcoded_handler?
      begin
        # tem "asuming variable is not empty"
        HAMDLERS.fetch(clear_text.to_sym)
      rescue
        # tem "Command unknown."
        false
      end
    end

    def hardcoded_chat_handler?
      begin
        # tem "asuming variable is not empty"
        CHAT_HAMDLERS.fetch(clear_text.to_sym)
      rescue
        # tem "Command unknown."
        false
      end
    end

    def has_referal?
      return false if (callback_query? || file? || location?)
      ref = clear_text
      puts "clear text: #{ref}"
      if @payload.text
        puts "payload text: #{@payload.text}"
        cmd = @payload.text.split(' ').first
        if cmd == '/start' && "/#{ref}" != '/start'
          puts "got ref!!!"
          decoded = Base64.decode64(clear_text)
          puts "decoded #{decoded}"
          master = Client.find(tele: decoded)
          puts "master: #{master}"
          if !master.nil?
            return master
          else
            return false
          end
        else
          return false
        end
      else
        return false
      end
    end

    def parse_chat_method
      # hardcoded handler
      # ust call it without params
      mess = hardcoded_chat_handler?
      # tem "#{mess} command in hardcoded list."
      # tem "skipping other conditions."
      return [mess, nil] if mess != false

      # not in hardcoded handlers list
      # and handler is NOT set
      if !handler?
        # tem "no message, no handler"
        # tem "replying with error"
        return ['no_command', nil]
      else
        # not in hardcoded handlers list
        # and handler is set
        # tem "handler is set."
        if message?
          # tem "processing message with variable"
          # tem "cmd: #{handler?}, var: #{clear_text}"
          return [handler?, clear_text]
        end
      end
    end


    def parse_method
      puts 'checking referal'
      referal = has_referal?
      puts "got: #{referal}"
      if referal != false
        puts "SO WHAT?"
        if referal.id != hb_client.id
          puts "Adding @#{hb_client.username} as referal to @#{referal.username}"
          Referal.find_or_create(referal: hb_client.id, client: referal.id)
        end
        return ['start', nil]
      end

      # hardcoded handler
      # ust call it without params
      mess = hardcoded_handler?
      # tem "#{mess} command in hardcoded list."
      # tem "skipping other conditions."
      return [mess, nil] if mess != false

      # not in hardcoded handlers list
      # and handler is NOT set
      if !handler?
        # tem "no message, no handler"
        # tem "replying with error"
        return ['no_command', nil]
      else
        # not in hardcoded handlers list
        # and handler is set
        # tem "handler is set."
        if message?
          # tem "processing message with variable"
          # tem "cmd: #{handler?}, var: #{clear_text}"
          return [handler?, clear_text]
        end
        if callback_query?
          # puts "processing callback_query with variable"
          # puts "cmd: #{handler?}, var: #{clear_data}"
          return [handler?, clear_data]
        end
        if file?
          puts "FILEEEE EEEEE"
          puts file?
          return [handler?, file?]
        end
      end

    end

    private

    def json_load(request_body)
      request_body.rewind
      body = request_body.read
      MultiJson.load body
    end

    def extract_message(update)
      types = %w(inline_query
       chosen_inline_result
       callback_query
       edited_message
       message
       channel_post
       edited_channel_post)
      types.inject(nil) { |acc, elem| acc || update.public_send(elem) }
    end

  end
end
