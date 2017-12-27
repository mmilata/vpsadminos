module OsCtld
  class Commands::Container::Show < Commands::Base
    handle :ct_show

    include Utils::Log
    include Utils::System
    include Utils::SwitchUser

    def execute
      ct = ContainerList.find(opts[:id])
      return error('container not found') unless ct

      ct.inclusively do
        ok({
          id: ct.id,
          user: ct.user.name,
          group: ct.group.name,
          dataset: ct.dataset,
          rootfs: ct.rootfs,
          lxc_path: ct.lxc_home,
          lxc_dir: ct.lxc_dir,
          distribution: ct.distribution,
          version: ct.version,
          state: ct.state,
          init_pid: ct.init_pid,
        })
      end
    end
  end
end