Config {
    -- appearance
      font        = "Noto Sans Mono Bold 11"
    , additionalFonts =
        [ "Font Awesome 6 Free Solid 11"
        ]
    , bgColor     = "#000000"
    , fgColor     = "#dfbf8e"
    , position    = TopH 30
    , dpi         = 140
    , template    = " %StdinReader%}{%mail% | %bright% | %multicoretemp% | %headset%%battery% | %network% | %time% | %date% | %kbd% "
    , commands = 
        [ Run StdinReader
	, Run Com "/home/riscadoa/nixos/bin/sb-gmail.sh" [] "mail" 100
	, Run Com "/home/riscadoa/nixos/bin/sb-headset.sh" [] "headset" 10
	, Run Com "/home/riscadoa/nixos/bin/sb-network.sh" [] "network" 10
        , Run Brightness     [ "--template" , "\xf185 <percent>%"
                             , "--", "-D", "intel_backlight"
                             ] 5 
        , Run MultiCoreTemp  [ "--template" , "\xf2c8 <maxpc>°C"
	                     , "--Low", "60"
			     , "--High", "90"
			     ] 10
	, Run Battery        [ "--template" , "<acstatus>"
                             , "--" -- battery specific options
                                       -- discharging status
                                       , "-o"	, "\xf240 <left>% (<timeleft>)"
                                       -- AC "on" status
                                       , "-O"	, "\xf1e6 <left>%"
                                       -- charged status
                                       , "-i"	, "\xf1e6 100%"
                             ] 50
        , Run Date           "\xf073 %F (%a)" "date" 10
        , Run Date           "\xf017 %T" "time" 10
        , Run Kbd           [ ("pt", "\xf11c PT"), ("us(cmk_ed_dh)", "\xf11c CMK"), ("us(altgr-intl)", "\xf11c US") ] 
        ]
}
