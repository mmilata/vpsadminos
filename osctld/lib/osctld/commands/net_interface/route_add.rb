require 'osctld/commands/logged'
require 'ipaddress'

module OsCtld
  class Commands::NetInterface::RouteAdd < Commands::Logged
    handle :netif_route_add

    include OsCtl::Lib::Utils::Log
    include OsCtl::Lib::Utils::System
    include Utils::SwitchUser

    def find
      ct = DB::Containers.find(opts[:id], opts[:pool])
      ct || error!('container not found')
    end

    def execute(ct)
      netif = ct.netifs.detect { |n| n.name == opts[:name] }
      netif || error!('network interface not found')
      netif.type == :routed || error!('not a routed interface')

      addr = IPAddress.parse(opts[:addr])
      ip_v = addr.ipv4? ? 4 : 6

      ct.exclusively do
        # TODO: check that no other container routes this IP
        error!('this address is already routed') if netif.routes.route?(addr)

        unless netif.can_route_ip?(addr)
          error!("network interface not configured for IPv#{ip_v}")
        end

        netif.add_route(addr)
        ct.save_config
        ct.configure_network

        DistConfig.run(ct, :network)

        ok
      end
    end
  end
end