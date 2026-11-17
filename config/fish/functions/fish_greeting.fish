function fish_greeting
    echo Yo, (whoami), you\'re logged on $hostname.
    echo The time is (set_color yellow; date +%T; set_color normal) - perfect for doing something cool!
end
