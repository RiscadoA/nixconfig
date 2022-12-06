import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.Place
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.SetWMName
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(additionalKeys)
import XMonad.Layout.NoBorders
import XMonad.Layout.Spacing
import XMonad.Layout.PerWorkspace
import System.IO
import Data.List
import Data.Maybe

import qualified Graphics.X11.ExtraTypes.XF86 as XF86

myManageHook = composeAll
    [ isFullscreen           --> doFullFloat
    , className =? "Gimp"    --> doFloat
    , className =? "Code"    --> doShift "code"
    , className =? "Firefox" --> doShift "network"
    , className =? "discord" --> doShift "discord"
    , className =? "Slack" --> doShift "team"
    , className =? "Mattermost" --> doShift "team"
    , className =? "zoom"    --> doShift "video"
    , className =? "" --> doShift "music" -- Spotify
    ]
myPlaceHook = placeHook (withGaps (16,0,16,0) (smart (0.5, 0.5)))

layoutFull = (noBorders Full)
layoutSingle = (avoidStruts (noBorders Full))
layoutTiled = (lessBorders OnlyFloat (avoidStruts (spacingRaw False (Border 5 5 5 5) True (Border 5 5 5 5) True $ Tall 1 (10/100) (50/100))))
layoutAll = (layoutSingle ||| layoutFull ||| layoutTiled)

main = do
    xmproc <- spawnPipe "xmobar ~/.xmonad/xmobar.hs"
    xmonad $ ewmhFullscreen . ewmh $ docks def
        { manageHook = myManageHook <+> myPlaceHook  <+> manageHook def
        , layoutHook = onWorkspace "terminal" layoutTiled $
	               onWorkspaces ["network", "other"] layoutAll $
                       onWorkspaces ["video", "code"] (layoutSingle ||| layoutFull) $
                       layoutSingle
        , logHook    = dynamicLogWithPP xmobarPP
                           { ppOutput          = hPutStrLn xmproc
                           , ppCurrent         = xmobarColor "#e3a84e" "" . workspaceIcon
                           , ppVisible         = xmobarColor "#ebdbb2" "" . workspaceIcon
                           , ppHidden          = xmobarColor "#dfbf8e" "" . workspaceIcon
                           , ppHiddenNoWindows = xmobarColor "#dfbf8e" "" . workspaceIcon
                           , ppUrgent          = xmobarColor "red" "yellow" . workspaceIcon
                           , ppTitle           = xmobarColor "#e3a84e" "" . shorten 50
                           } >> setWMName "LG3D"
	    , handleEventHook    = handleEventHook def
        , modMask            = mod4Mask
        , terminal           = "alacritty"
        , focusFollowsMouse  = True
        , clickJustFocuses   = True
        , borderWidth        = 2
        , normalBorderColor  = "#665c54"
        , focusedBorderColor = "#e3a84e" 
        , workspaces         = myWorkspaces
        } `additionalKeys`
        [ ((mod4Mask .|. shiftMask, xK_l), spawn "slock")
        , ((mod4Mask .|. controlMask, xK_Left), spawn "playerctl previous")
        , ((mod4Mask .|. controlMask, xK_Right), spawn "playerctl next")
        , ((mod4Mask .|. controlMask, xK_Up), spawn "playerctl play")
        , ((mod4Mask .|. controlMask, xK_Down), spawn "playerctl pause")
        , ((mod4Mask, xK_F8), spawn "light -U 5")
        , ((mod4Mask, xK_F9), spawn "light -A 5")
        , ((0, xK_Print), spawn "flameshot gui")
        ]


myWorkspaces :: [WorkspaceId]
myWorkspaces =
    [ "terminal"
    , "code"
    , "network"
    , "discord"
    , "team"
    , "video"
    , "windows"
    , "other"
    , "music"
    ]

workspaceIcons =
    [ "\xf120"
    , "\xf1c9"
    , "\xf269"
    , "\xf392"
    , "\xf0c0"
    , "\xf008"
    , "\xf17a"
    , "\xf0eb"
    , "\xf001"
    ]

workspaceIcon :: String -> String
workspaceIcon id = workspaceIcons !! (fromJust $ elemIndex id myWorkspaces)

