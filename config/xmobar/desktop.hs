Config {
    -- appearance
      font        = "Noto Sans Mono Bold 11"
    , additionalFonts =
        [ "Font Awesome 6 Free Solid 11"
        ]
    , bgColor     = "#000000"
    , fgColor     = "#dfbf8e"
    , position    = Top
    , template    = "%StdinReader%}{%mail% | %time% | %date% | %kbd% "
    , commands = 
        [ Run StdinReader
	    , Run Com  "/home/riscadoa/nixos/bin/sb-gmail.sh" [] "mail" 100
        , Run Date "\xf073 %F (%a)" "date" 10
        , Run Date "\xf017 %T" "time" 10
        , Run Kbd  [ ("pt", "\xf11c PT"), ("us(cmk_ed_dh)", "\xf11c CMK") ] 
        ]
}
