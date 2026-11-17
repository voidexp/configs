set help "
Usage: alarm INTERVAL

Play an alarm sound after some time.

Examples:
  alarm 30s  # Sound the alarm after 30 seconds
  alarm 1h   # Sound the alarm after 1 hour

For valid INTERAVAL values, see sleep(1)
"

function alarm
    argparse h/help -- $argv or return

    if set -ql _flag_help
        echo $help
        return 0
    end

    sleep $argv[1]
    ogg123 -q /usr/share/sounds/LinuxMint/stereo/phone-incoming-call.ogg
end
