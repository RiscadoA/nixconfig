Config {
    -- appearance
      font        = "xft:Noto Sans Mono:size=11:bold:antialias=true:hinting=true,Font Awesome 5 Free Solid:size=11:antialias=true:hinting=true:style=Solid,Font Awesome 5 Brands:size=11:antialias=true:hinting=true:style=Regular"
    , bgColor     = "#000000"
    , fgColor     = "#dfbf8e"
    , position    = Top
    , template    = "%StdinReader%}{%tasks% | %mail% | %time% | %date% | %kbd% "
    , commands = 
        [ Run StdinReader
	, Run Com "/etc/nixos/bin/sb-tasks.sh" [] "tasks" 100
	, Run Com "/etc/nixos/bin/sb-gmail.sh" [] "mail" 100
        , Run Date           "\xf073 %F (%a)" "date" 10
        , Run Date           "\xf017 %T" "time" 10
        , Run Kbd           [ ("pt", "\xf11c PT"), ("us(cmk_ed_dh)", "\xf11c CMK") ] 
        ]
}
