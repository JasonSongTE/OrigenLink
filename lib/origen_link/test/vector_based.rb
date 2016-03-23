require 'origen_link/vector_based'

module OrigenLink
  module Test
    class VectorBased < ::OrigenLink::VectorBased
      attr_accessor :message, :microcodestr, :test_response

      def send_cmd(cmdstr, argstr)
        @message = cmdstr + ':' + argstr
        @test_response
      end

      def setup_cmd_response_logger(command, response)
      end

      def microcode(msg)
        @microcodestr = @microcodestr + msg
      end
    end
  end
end
