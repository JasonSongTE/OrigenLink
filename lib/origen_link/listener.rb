require 'sinatra/base'
module OrigenLink
  class Listener < Sinatra::Base
    def self.port
      @port || 20_020
    end

    def self.target_object
      @target_object || dut
    end

    def self.run!(options = {})
      @port = options[:port] if options[:port]
      @target_object = options[:dut]
      super
    end

    def target_object
      self.class.target_object
    end

    def expand_path(path)
      path.split('.').each do |p|
        if p =~ /(.*)\[(\d+)(:(\d+))?\]$/
          msb = Regexp.last_match(2).to_i
          lsb = Regexp.last_match(4).to_i if Regexp.last_match(4)
          yield Regexp.last_match(1)
          if lsb
            yield '[]', msb..lsb
          else
            yield '[]', msb
          end
        else
          yield p
        end
      end
    end

    get '/hello_world' do
      'Hello there'
    end

    get '/dut_class' do
      target_object.class.to_s
    end

    post '/write_register' do
      t = target_object
      expand_path(params[:path]) do |method, arg|
        if arg
          t = t.send(method, arg)
        else
          t = t.send(method)
        end
      end
      t.write!(params[:data].to_i)
      nil
    end
  end
end
