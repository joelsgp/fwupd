function __fish_fwupdmgr_devices --description 'Get device IDs used by fwupdmgr'
    set -l ids (fwupdmgr get-devices | string replace -f -r '.*Device ID:\s*(.*)' '$1')
    set -l names (fwupdmgr get-devices | string replace -f -r '.*─(.*):$' '$1')
    for i in (seq (count $ids))
        echo -e "$ids[$i]\t$names[$i]"
    end
end

function __fish_fwupdmgr_remotes --description 'Get remote IDs used by fwupdmgr'
    fwupdmgr get-remotes | string replace -f -r '.*Remote ID:\s*(.*)' '$1'
end


# complete options
complete -c fwupdmgr -s h -l help -d 'Show help options'
complete -c fwupdmgr -s v -l verbose -d 'Show extra debugging information'
complete -c fwupdmgr -l version -d 'Show client and daemon versions'
complete -c fwupdmgr -l offline -d 'Schedule installation for next reboot when possible'
complete -c fwupdmgr -l allow-reinstall -d 'Allow reinstalling existing firmware versions'
complete -c fwupdmgr -l allow-older -d 'Allow downgrading firmware versions'
complete -c fwupdmgr -l allow-branch-switch -d 'Allow switching firmware branch'
complete -c fwupdmgr -l force -d 'Force the action by relaxing some runtime checks'
complete -c fwupdmgr -s y -l assume-yes -d 'Answer yes to all questions'
complete -c fwupdmgr -l sign -d 'Sign the uploaded data with the client certificate'
complete -c fwupdmgr -l no-unreported-check -d 'Do not check for unreported history'
complete -c fwupdmgr -l no-metadata-check -d 'Do not check for old metadata'
complete -c fwupdmgr -l no-reboot-check -d 'Do not check or prompt for reboot after update'
complete -c fwupdmgr -l no-safety-check -d 'Do not perform device safety checks'
complete -c fwupdmgr -l no-history -d 'Do not write to the history database'
complete -c fwupdmgr -l show-all -d 'Show all results'
complete -c fwupdmgr -l disable-ssl-strict -d 'Ignore SSL strict checks when downloading'
complete -c fwupdmgr -l ipfs -d 'Use IPFS when downloading files'
complete -c fwupdmgr -l filter -d 'Filter with a set of device flags'

# complete subcommands
complete -c fwupdmgr -n '__fish_use_subcommand' -x -a activate -d 'Activate devices'
complete -c fwupdmgr -n '__fish_use_subcommand' -x -a block-firmware -d 'Blocks a specific firmware from being installed'
complete -c fwupdmgr -n '__fish_use_subcommand' -x -a clear-results -d 'Clears the results from the last update'
complete -c fwupdmgr -n '__fish_use_subcommand' -x -a disable-remote -d 'Disables a given remote'
complete -c fwupdmgr -n '__fish_use_subcommand' -x -a downgrade -d 'Downgrades the firmware on a device'
complete -c fwupdmgr -n '__fish_use_subcommand' -x -a enable-remote -d 'Enables a given remote'
complete -c fwupdmgr -n '__fish_use_subcommand' -x -a get-approved-firmware -d 'Gets the list of approved firmware'
complete -c fwupdmgr -n '__fish_use_subcommand' -x -a get-blocked-firmware -d 'Gets the list of blocked firmware'
complete -c fwupdmgr -n '__fish_use_subcommand' -x -a get-bios-setting -d 'Retrieve BIOS setting'
complete -c fwupdmgr -n '__fish_use_subcommand' -x -a get-details -d 'Gets details about a firmware file'
complete -c fwupdmgr -n '__fish_use_subcommand' -x -a get-devices -d 'Get all devices that support firmware updates'
complete -c fwupdmgr -n '__fish_use_subcommand' -x -a get-history -d 'Show history of firmware updates'
complete -c fwupdmgr -n '__fish_use_subcommand' -x -a get-releases -d 'Gets the releases for a device'
complete -c fwupdmgr -n '__fish_use_subcommand' -x -a get-remotes -d 'Gets the configured remotes'
complete -c fwupdmgr -n '__fish_use_subcommand' -x -a get-results -d 'Gets the results from the last update'
complete -c fwupdmgr -n '__fish_use_subcommand' -x -a get-updates -d 'Gets the list of updates for connected hardware'
complete -c fwupdmgr -n '__fish_use_subcommand' -x -a install -d 'Install a firmware file in cabinet format on this hardware'
complete -c fwupdmgr -n '__fish_use_subcommand' -x -a modify-config -d 'Modifies a daemon configuration value'
complete -c fwupdmgr -n '__fish_use_subcommand' -x -a modify-remote -d 'Modifies a given remote'
complete -c fwupdmgr -n '__fish_use_subcommand' -x -a refresh -d 'Refresh metadata from remote server'
complete -c fwupdmgr -n '__fish_use_subcommand' -x -a reinstall -d 'Reinstall current firmware on the device'
complete -c fwupdmgr -n '__fish_use_subcommand' -x -a report-history -d 'Share firmware history with the developers'
complete -c fwupdmgr -n '__fish_use_subcommand' -x -a set-bios-setting -d 'Set a BIOS setting'
complete -c fwupdmgr -n '__fish_use_subcommand' -x -a security -d 'Gets the host security attributes'
complete -c fwupdmgr -n '__fish_use_subcommand' -x -a set-approved-firmware -d 'Sets the list of approved firmware'
complete -c fwupdmgr -n '__fish_use_subcommand' -x -a switch-branch -d 'Switch the firmware branch on the device'
complete -c fwupdmgr -n '__fish_use_subcommand' -x -a unblock-firmware -d 'Unblocks a specific firmware from being installed'
complete -c fwupdmgr -n '__fish_use_subcommand' -x -a unlock -d 'Unlocks the device for firmware access'
complete -c fwupdmgr -n '__fish_use_subcommand' -x -a update -d 'Updates all firmware to latest versions available'
complete -c fwupdmgr -n '__fish_use_subcommand' -x -a verify -d 'Checks cryptographic hash matches firmware'
complete -c fwupdmgr -n '__fish_use_subcommand' -x -a verify-update -d 'Update the stored cryptographic hash with current ROM contents'
complete -c fwupdmgr -n '__fish_use_subcommand' -x -a inhibit -d 'Inhibit the system to prevent upgrades'
complete -c fwupdmgr -n '__fish_use_subcommand' -x -a uninhibit -d 'Uninhibit the system to allow upgrades'
complete -c fwupdmgr -n '__fish_use_subcommand' -x -a quit -d 'Asks the daemon to quit'
complete -c fwupdmgr -n '__fish_use_subcommand' -x -a emulation-load -d 'Load device emulation data'
complete -c fwupdmgr -n '__fish_use_subcommand' -x -a emulation-save -d 'Save device emulation data'
complete -c fwupdmgr -n '__fish_use_subcommand' -x -a emulation-tag -d 'Adds devices to watch for future emulation'
complete -c fwupdmgr -n '__fish_use_subcommand' -x -a emulation-untag -d 'Removes devices to watch for future emulation'

# commands exclusively consuming device IDs
set -l deviceid_consumers activate clear-results downgrade get-releases get-results get-updates reinstall switch-branch unlock update verify verify-update
# complete device IDs
complete -c fwupdmgr -n "__fish_seen_subcommand_from $deviceid_consumers" -x -a "(__fish_fwupdmgr_devices)"
# complete files and device IDs
complete -c fwupdmgr -n "__fish_seen_subcommand_from install" -r -a "(__fish_fwupdmgr_devices)"

# commands exclusively consuming remote IDs
set -l remoteid_consumers disable-remote enable-remote modify-remote
# complete remote IDs
complete -c fwupdmgr -n "__fish_seen_subcommand_from $remoteid_consumers" -x -a "(__fish_fwupdmgr_remotes)"
# complete files and remote IDs
complete -c fwupdmgr -n "__fish_seen_subcommand_from refresh" -r -a "(__fish_fwupdmgr_remotes)"
