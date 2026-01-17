function ll
    ls -lah --group-directories-first $argv
end

# Use vim for sudoedit
set -Ux EDITOR vim
set -Ux VISUAL vim

if not set -q SSH_AUTH_SOCK
    eval (ssh-agent -c) >/dev/null
end

if not set -q SSH_AUTH_SOCK
    eval (ssh-agent -c)
end

for key in ~/.ssh/*
    if test -f $key
        if not string match -q '*.pub' $key
            if not string match -q '*known_hosts*' $key
                if not string match -q '*config*' $key
                    ssh-add $key >/dev/null 2>&1
                end
            end
        end
    end
end

