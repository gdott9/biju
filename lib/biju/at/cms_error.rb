module Biju
  module AT
    # Message Service Failure
    class CmsError < Error
      ERRORS = {
        1 => 'Unassigned number',
        8 => 'Operator determined barring',
        10 => 'Call bared',
        21 => 'Short message transfer rejected',
        27 => 'Destination out of service',
        28 => 'Unindentified subscriber',
        29 => 'Facility rejected',
        30 => 'Unknown subscriber',
        38 => 'Network out of order',
        41 => 'Temporary failure',
        42 => 'Congestion',
        47 => 'Recources unavailable',
        50 => 'Requested facility not subscribed',
        69 => 'Requested facility not implemented',
        81 => 'Invalid short message transfer reference value',
        95 => 'Invalid message unspecified',
        96 => 'Invalid mandatory information',
        97 => 'Message type non existent or not implemented',
        98 => 'Message not compatible with short message protocol',
        99 => 'Information element non-existent or not implemente',
        111 => 'Protocol error, unspecified',
        127 => 'Internetworking , unspecified',
        128 => 'Telematic internetworking not supported',
        129 => 'Short message type 0 not supported',
        130 => 'Cannot replace short message',
        143 => 'Unspecified TP-PID error',
        144 => 'Data code scheme not supported',
        145 => 'Message class not supported',
        159 => 'Unspecified TP-DCS error',
        160 => 'Command cannot be actioned',
        161 => 'Command unsupported',
        175 => 'Unspecified TP-Command error',
        176 => 'TPDU not supported',
        192 => 'SC busy',
        193 => 'No SC subscription',
        194 => 'SC System failure',
        195 => 'Invalid SME address',
        196 => 'Destination SME barred',
        197 => 'SM Rejected-Duplicate SM',
        198 => 'TP-VPF not supported',
        199 => 'TP-VP not supported',
        208 => 'D0 SIM SMS Storage full',
        209 => 'No SMS Storage capability in SIM',
        210 => 'Error in MS',
        211 => 'Memory capacity exceeded',
        212 => 'Sim application toolkit busy',
        213 => 'SIM data download error',
        255 => 'Unspecified error cause',
        300 => 'ME Failure',
        301 => 'SMS service of ME reserved',
        302 => 'Operation not allowed',
        303 => 'Operation not supported',
        304 => 'Invalid PDU mode parameter',
        305 => 'Invalid Text mode parameter',
        310 => 'SIM not inserted',
        311 => 'SIM PIN required',
        312 => 'PH-SIM PIN required',
        313 => 'SIM failure',
        314 => 'SIM busy',
        315 => 'SIM wrong',
        316 => 'SIM PUK required',
        317 => 'SIM PIN2 required',
        318 => 'SIM PUK2 required',
        320 => 'Memory failure',
        321 => 'Invalid memory index',
        322 => 'Memory full',
        330 => 'SMSC address unknown',
        331 => 'No network service',
        332 => 'Network timeout',
        340 => 'No +CNMA expected',
        500 => 'Unknown error',
        512 => 'User abort',
        513 => 'Unable to store',
        514 => 'Invalid Status',
        515 => 'Device busy or Invalid Character in string',
        516 => 'Invalid length',
        517 => 'Invalid character in PDU',
        518 => 'Invalid parameter',
        519 => 'Invalid length or character',
        520 => 'Invalid character in text',
        521 => 'Timer expired',
        522 => 'Operation temporary not allowed',
        532 => 'SIM not ready',
        534 => 'Cell Broadcast error unknown',
        535 => 'Protocol stack busy',
        538 => 'Invalid parameter',
      }

      def initialize(id)
        super(id, 500)
      end
    end
  end
end
