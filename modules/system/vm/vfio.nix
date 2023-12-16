# modules/system/vm/vfio.nix
#
# Author: Ricardo Antunes <me@riscadoa.com>
# URL:    https://github.com/RiscadoA/nixconfig
#
# Windows virtual machine configuration.

{ lib, config, pkgs,... }:
let
  inherit (builtins) concatStringsSep;
  inherit (lib) mkEnableOption mkOption types mkMerge mkIf;
  cfg = config.modules.vm.vfio;

  devices = concatStringsSep "," cfg.devices;
in {
  options.modules.vm.vfio = {
    mode = mkOption {
      type = with types; uniq str;
      default = "none";
    };
    devices = mkOption {
      type = with types; listOf str;
      default = [];
    };
  };

  config = mkMerge [
    (mkIf (cfg.mode != "none") {
      boot = {
        kernelModules = [ "kvm-intel" "vfio_pci" "vfio" ];
        initrd.kernelModules = [ "vfio_pci" "vfio" ];
        kernelParams = [ "intel_iommu=on" "iommu=pt" ];
      };
      virtualisation = {
        libvirtd = {
          enable = true;
          onBoot = "ignore";
          onShutdown = "shutdown";
          qemu = {
            package = pkgs.qemu_kvm;
            ovmf = {
              enable = true;
              packages = [ pkgs.OVMFFull.fd ];
            };
            runAsRoot = true;
            swtpm.enable = true;
          };
        };
        spiceUSBRedirection.enable = true;
      };
      
      programs.dconf.enable = true;
      environment.systemPackages = with pkgs; [
        virt-manager
        spice-gtk
        looking-glass-client
        swtpm
      ];
      
      systemd.tmpfiles.rules = [ "f /dev/shm/looking-glass 666 root libvirtd -" ];
    })
    (mkIf (cfg.mode == "dual") {
      specialisation.vfio.configuration = {
        boot = {
          blacklistedKernelModules = [ "nvidia" "nouveau" ];
          kernelParams = [ (concatStringsSep "=" [ "vfio-pci.ids" devices ]) ];
        };
      };
    })
    (mkIf (cfg.mode == "single") {
      services.x2goserver.enable = true;

      boot.kernelParams = [ "nomodeset" ];

      # Add binaries to path so that hooks can use it.
      systemd.services.libvirtd.path = [
        (pkgs.buildEnv {
          name = "qemu-hook-env";
          paths = with pkgs; [
            bash
            libvirt
            kmod
            systemd
            ripgrep
            sd
          ];
        })
      ];

      # Link hooks to the correct directory
      system.activationScripts.libvirt-hooks.text = ''
        ln -Tfs /etc/libvirt/hooks /var/lib/libvirt/hooks
      '';
    
      environment.etc = {
        "libvirt/hooks/qemu" = {
          text = ''
            #!/run/current-system/sw/bin/bash
            #
            # Author: Sebastiaan Meijer (sebastiaan@passthroughpo.st)
            #
            # Copy this file to /etc/libvirt/hooks, make sure it's called "qemu".
            # After this file is installed, restart libvirt.
            # From now on, you can easily add per-guest qemu hooks.
            # Add your hooks in /etc/libvirt/hooks/qemu.d/vm_name/hook_name/state_name.
            # For a list of available hooks, please refer to https://www.libvirt.org/hooks.html
            #
    
            GUEST_NAME="$1"
            HOOK_NAME="$2"
            STATE_NAME="$3"
            MISC="''${@:4}"
    
            BASEDIR="$(dirname $0)"
    
            HOOKPATH="$BASEDIR/qemu.d/$GUEST_NAME/$HOOK_NAME/$STATE_NAME"
    
            set -e # If a script exits with an error, we should as well.
    
            # check if it's a non-empty executable file
            if [ -f "$HOOKPATH" ] && [ -s "$HOOKPATH"] && [ -x "$HOOKPATH" ]; then
                eval \"$HOOKPATH\" "$@"
            elif [ -d "$HOOKPATH" ]; then
                while read file; do
                    # check for null string
                    if [ ! -z "$file" ]; then
                      eval \"$file\" "$@"
                    fi
                done <<< "$(find -L "$HOOKPATH" -maxdepth 1 -type f -executable -print;)"
            fi
          '';
          mode = "0755";
        };

        "libvirt/hooks/kvm.conf" = {
            text = ''
              VIRSH_GPU_VIDEO=pci_0000_01_00_0
              VIRSH_GPU_AUDIO=pci_0000_01_00_1
            '';
            mode = "0755";
        };

        "libvirt/hooks/qemu.d/win11/prepare/begin/start.sh" = {
          text = ''
            #!/run/current-system/sw/bin/bash

            # Debugging
            exec 19>/home/riscadoa/desktop/startlogfile
            BASH_XTRACEFD=19
            set -x
    
            # Load variables we defined
            source "/etc/libvirt/hooks/kvm.conf"
    
            systemctl set-property --runtime -- user.slice AllowedCPUs=20-23
            systemctl set-property --runtime -- system.slice AllowedCPUs=20-23
            systemctl set-property --runtime -- init.scope AllowedCPUs=20-23
            echo "Isolated host to CPUs 20-23"

            loginctl terminate-session
            echo "Logged out"

            systemctl stop display-manager.service
            echo "Stopped display manager"

            echo 0 > /sys/class/vtconsole/vtcon0/bind
            echo 0 > /sys/class/vtconsole/vtcon1/bind
            echo "Unbinded VTconsoles"

            echo efi-framebuffer.0 > /sys/bus/platform/drivers/efi-framebuffer/unbind
            echo "Unbinded EFI framebuffer"

            # Avoid race condition
            sleep 5

            modprobe -r nvidia_drm nvidia_modeset nvidia_uvm nvidia
            echo "Unloaded NVIDIA kernel modules"

            modprobe vfio-pci
            echo "Loaded VFIO module"
          '';
          mode = "0755";
        };

        "libvirt/hooks/qemu.d/win11/release/end/stop.sh" = {
          text = ''
            #!/run/current-system/sw/bin/bash

            # Debugging
            exec 19>/home/riscadoa/desktop/stoplogfile
            BASH_XTRACEFD=19
            set -x
    
            # Load variables we defined
            source "/etc/libvirt/hooks/kvm.conf"

            modprobe -r vfio-pci
            echo "Unloaded VFIO module"

            echo 1 > /sys/bus/pci/devices/0000:01:00.0/remove
            echo 1 > /sys/bus/pci/devices/0000:01:00.1/remove
            echo 1 > /sus/bus/pci/rescan

            modprobe nvidia_drm nvidia_modeset nvidia_uvm nvidia
            echo "Loaded NVIDIA kernel modules"

            # Avoid race condition
            sleep 5

            echo efi-framebuffer.0 > /sys/bus/platform/drivers/efi-framebuffer/bind
            echo "Binded EFI framebuffer"

            echo 1 > /sys/class/vtconsole/vtcon0/bind
            echo 1 > /sys/class/vtconsole/vtcon1/bind
            echo "Binded VTconsoles"

            systemctl start display-manager.service
            echo "Started display manager"

            systemctl set-property --runtime -- user.slice AllowedCPUs=0-23
            systemctl set-property --runtime -- system.slice AllowedCPUs=0-23
            systemctl set-property --runtime -- init.scope AllowedCPUs=0-23
            echo "Return host to all CPUs"
          '';
          mode = "0755";
        };
      };
    })
  ];
}

