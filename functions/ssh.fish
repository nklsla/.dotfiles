# Wrapper: ssh changes the konsole tab's colorscheme via LocalCommand;
# nothing restores it when the session ends, so reset back to Breath
# after any ssh invocation. konsoleprofile talks to konsole by printing
# an escape sequence to stdout, so stdout must NOT be redirected — guard
# on KONSOLE_DBUS_SESSION (only set inside konsole) to keep other
# terminals free of stray escape codes.
function ssh
    command ssh $argv
    set -l st $status
    if set -q KONSOLE_DBUS_SESSION
        konsoleprofile 'ColorScheme=Breath;TabColor=#1E2229'
    end
    return $st
end
