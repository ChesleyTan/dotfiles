import XMonad
import XMonad.Actions.CycleWS
import XMonad.Actions.GridSelect
import XMonad.Actions.NoBorders
import XMonad.Actions.UpdatePointer
import XMonad.Actions.WorkspaceNames
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.Minimize
import XMonad.Layout.Grid
import XMonad.Layout.Spacing
import XMonad.Layout.Maximize
import XMonad.Layout.Minimize
import XMonad.Layout.MosaicAlt
import XMonad.Layout.Named
import XMonad.Layout.NoBorders
import XMonad.Layout.PerWorkspace
import XMonad.Layout.SimplestFloat
import XMonad.Layout.TwoPane
import XMonad.Prompt
import XMonad.Util.Run
import Data.Monoid
import System.Exit

import qualified XMonad.StackSet as W
import qualified Data.Map        as M

-- The preferred terminal program, which is used in a binding below and by
-- certain contrib modules.
--
myTerminal      = "xterm"

-- Whether focus follows the mouse pointer.
myFocusFollowsMouse :: Bool
myFocusFollowsMouse = True

-- Width of the window border in pixels.
--
myBorderWidth   = 1

-- modMask lets you specify which modkey you want to use. The default
-- is mod1Mask ("left alt").  You may also consider using mod3Mask
-- ("right alt"), which does not conflict with emacs keybindings. The
-- "windows key" is usually mod4Mask.
--
myModMask       = mod4Mask

-- The default number of workspaces (virtual screens) and their names.
-- By default we use numeric strings, but any string may be used as a
-- workspace name. The number of workspaces is determined by the length
-- of this list.
--
-- A tagging example:
--
-- > workspaces = ["web", "irc", "code" ] ++ map show [4..9]
--
myWorkspaces = ["1:main","2:web","3:office","4:doc","5:float","6","7","8","9"]

-- Border colors for unfocused and focused windows, respectively.
--
myNormalBorderColor = "#353535"
myFocusedBorderColor = "#48D700"

-- GridSelect module configuration
gsconfig2 colorizer = (buildDefaultGSConfig colorizer) { gs_cellheight = 50
                                                       , gs_cellwidth = 300
                                                       , gs_cellpadding = 6
                                                       , gs_font = "xft:Ubuntu:regular:size=11"
}

greenColorizer = colorRangeFromClassName
                    (0x44, 0x44, 0x44)  -- lowest inactive bg
                    (0x00, 0xFF, 0x5F)  -- highest inactive bg
                    (0x00, 0x5F, 0xFF)  -- active bg
                    white               -- inactive fg
                    white               -- active fg
    where black = (0x00, 0x00, 0x00)
          white = (0xFF, 0xFF, 0xFF)

------------------------------------------------------------------------
-- Key bindings. Add, modify or remove key bindings here.
--
myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $

    -- launch a terminal
    [ ((modm .|. shiftMask, xK_Return), spawn $ XMonad.terminal conf)

    -- toggle albert
    , ((modm,               xK_p), spawn "albert toggle")

    -- close focused window
    , ((modm .|. shiftMask, xK_c     ), kill)

     -- Rotate through the available layout algorithms
    , ((modm,               xK_space ), sendMessage NextLayout)

    --  Reset the layouts on the current workspace to default
    , ((modm .|. shiftMask, xK_space ), setLayout $ XMonad.layoutHook conf)

    -- Resize viewed windows to the correct size
    , ((modm,               xK_n     ), refresh)

    -- Move focus to the next window
    , ((modm,               xK_Tab   ), windows W.focusDown)

    -- Move focus to the next window
    , ((modm,               xK_j     ), windows W.focusDown)

    -- Move focus to the previous window
    , ((modm,               xK_k     ), windows W.focusUp  )

    -- Move focus to the master window
    , ((modm,               xK_m     ), windows W.focusMaster  )

    -- Swap the focused window and the master window
    , ((modm,               xK_Return), windows W.swapMaster)

    -- Swap the focused window with the next window
    , ((modm .|. shiftMask, xK_j     ), windows W.swapDown  )

    -- Swap the focused window with the previous window
    , ((modm .|. shiftMask, xK_k     ), windows W.swapUp    )

    -- Shrink the master area
    , ((modm,               xK_h     ), sendMessage Shrink)

    -- Expand the master area
    , ((modm,               xK_l     ), sendMessage Expand)

    -- Push window back into tiling
    , ((modm,               xK_t     ), withFocused $ windows . W.sink)

    -- Increment the number of windows in the master area
    , ((modm              , xK_comma ), sendMessage (IncMasterN 1))

    -- Deincrement the number of windows in the master area
    , ((modm              , xK_period), sendMessage (IncMasterN (-1)))

    -- Toggle the status bar gap
    -- Use this binding with avoidStruts from Hooks.ManageDocks.
    -- See also the statusBar function from Hooks.DynamicLog.
    --
    , ((modm              , xK_b     ), sendMessage ToggleStruts)

    -- Quit xmonad
    , ((modm .|. shiftMask, xK_q     ), io (exitWith ExitSuccess))

    -- Restart xmonad
    , ((modm              , xK_q     ), spawn "xmonad --recompile; xmonad --restart")

    -- Run GridSelect module
    , ((modm              , xK_g), goToSelected $ gsconfig2 greenColorizer)

    -- Minimize keybindings
    , ((modm,               xK_m), withFocused minimizeWindow)
    , ((modm .|. shiftMask, xK_m), sendMessage RestoreNextMinimizedWin)

    -- Maximize keybindings
    , ((modm, xK_z), withFocused (sendMessage . maximizeRestore))

    -- Screenshot keybinding
    , ((0, xK_Print), spawn "scrot -e 'mv $f ~/Pictures/$f'")

    -- Cycle workspaces (XMonad.Actions.CycleWS)
    , ((modm,               xK_Right),  nextWS)
    , ((modm,               xK_Left),    prevWS)
    , ((modm .|. shiftMask, xK_Right),  shiftToNext)
    , ((modm .|. shiftMask, xK_Left),    shiftToPrev)
    , ((modm,               xK_Down), nextScreen)
    , ((modm,               xK_Up),  prevScreen)
    , ((modm .|. shiftMask, xK_Down), shiftNextScreen)
    , ((modm .|. shiftMask, xK_Up),  shiftPrevScreen)

    -- Toggle borders (XMonad.Actions.NoBorders)
    , ((modm .|. shiftMask, xK_b), withFocused toggleBorder)

    -- Rename workspaces
    , ((modm .|. shiftMask, xK_comma), renameWorkspace defaultXPConfig)

    -- Lock screen
    , ((modm .|. shiftMask, xK_l), spawn "dbus-send --type=method_call --dest=org.gnome.ScreenSaver /org/gnome/ScreenSaver org.gnome.ScreenSaver.Lock")
    ]
    ++

    -- mod-[1..9], Switch to workspace N
    -- mod-shift-[1..9], Move client to workspace N
    --
    [((m .|. modm, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
    ++

    --
    -- mod-{w,e,r}, Switch to physical/Xinerama screens 1, 2, or 3
    -- mod-shift-{w,e,r}, Move client to screen 1, 2, or 3
    --
    [((m .|. modm, key), screenWorkspace sc >>= flip whenJust (windows . f))
        | (key, sc) <- zip [xK_w, xK_e, xK_r] [0..]
        , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]


------------------------------------------------------------------------
-- Mouse bindings: default actions bound to mouse events
--
myMouseBindings (XConfig {XMonad.modMask = modm}) = M.fromList $

    -- mod-button1, Set the window to floating mode and move by dragging
    [ ((modm, button1), (\w -> focus w >> mouseMoveWindow w
                                       >> windows W.shiftMaster))

    -- mod-button2, Raise the window to the top of the stack
    , ((modm, button2), (\w -> focus w >> windows W.shiftMaster))

    -- mod-button3, Set the window to floating mode and resize by dragging
    , ((modm, button3), (\w -> focus w >> mouseResizeWindow w
                                       >> windows W.shiftMaster))

    -- you may also bind events to the mouse scroll wheel (button4 and button5)
    ]

------------------------------------------------------------------------
-- Layouts:

-- You can specify and transform your layouts by modifying these values.
-- If you change layout bindings be sure to use 'mod-shift-space' after
-- restarting (with 'mod-q') to reset your layout state to the new
-- defaults, as xmonad preserves your old layout settings by default.
--
-- * NOTE: XMonad.Hooks.EwmhDesktops users must remove the obsolete
-- ewmhDesktopsLayout modifier from layoutHook. It no longer exists.
-- Instead use the 'ewmh' function from that module to modify your
-- defaultConfig as a whole. (See also logHook, handleEventHook, and
-- startupHook ewmh notes.)
--
-- The available layouts.  Note that each layout is separated by |||,
-- which denotes layout choice.
--
baseLayout = Tall nmaster delta ratio where
    -- The default number of windows in the master pane
    nmaster = 1
    -- Default proportion of screen occupied by master pane
    ratio   = 1/2
    -- Percent of screen to increment by when resizing panes
    delta   = 1/100

-- default tiling algorithm partitions the screen into two panes
tallLayout       = named "tall"     (maximize (minimize (spacing 3 (avoidStruts (baseLayout)))))
wideLayout       = named "wide"     (maximize (minimize (spacing 3 (avoidStruts (Mirror (baseLayout))))))
fullLayout       = named "full"     (maximize (minimize (noBorders (avoidStruts (Full)))))
gridLayout       = named "grid"     (maximize (minimize (spacing 2 (avoidStruts (Grid)))))
mosaicLayout     = named "mosaic"   (maximize (minimize (spacing 2 (avoidStruts (MosaicAlt M.empty)))))
twoPaneLayout    = named "two pane" (maximize (minimize (avoidStruts (TwoPane (3/100) (1/2)))))
floatLayout      = named "float"    (maximize (minimize (avoidStruts (simplestFloat))))

myLayout = onWorkspace "5:float" floatLayout $
           tallLayout ||| mosaicLayout ||| gridLayout ||| fullLayout ||| wideLayout ||| twoPaneLayout ||| floatLayout

------------------------------------------------------------------------
-- Window rules:

-- Execute arbitrary actions and WindowSet manipulations when managing
-- a new window. You can use this to, for example, always float a
-- particular program, or have a client always appear on a particular
-- workspace.
--
-- To find the property name associated with a program, use
-- > xprop | grep WM_CLASS
-- and click on the client you're interested in.
--
-- To match on the WM_NAME, you can use 'title' in the same way that
-- 'className' and 'resource' are used below.
--
myManageHook = composeAll
    [ className =? "MPlayer"              --> doFloat
    , resource  =? "desktop_window"       --> doIgnore
    , resource  =? "kdesktop"             --> doIgnore
    , className =? "Google-chrome-stable" --> doShift "2:web"
    , className =? "Google-chrome"        --> doShift "2:web"
    , className =? "Firefox"              --> doShift "2:web"
    , className =? "Gimp"                 --> doShift "5:float"
    , className =? "Gimp-2.8"             --> doShift "5:float"
    , className =? "libreoffice-writer"   --> doShift "3:office"
    , className =? "Zeal"                 --> doShift "4:doc"
    ]

------------------------------------------------------------------------
-- Event handling

-- Defines a custom handler function for X Events. The function should
-- return (All True) if the default handler is to be run afterwards. To
-- combine event hooks use mappend or mconcat from Data.Monoid.
--
-- * NOTE: EwmhDesktops users should use the 'ewmh' function from
-- XMonad.Hooks.EwmhDesktops to modify their defaultConfig as a whole.
-- It will add EWMH event handling to your custom event hooks by
-- combining them with ewmhDesktopsEventHook.
--
myEventHook = minimizeEventHook

------------------------------------------------------------------------
-- Status bars and logging

-- Perform an arbitrary action on each internal state change or X event.
-- See the 'XMonad.Hooks.DynamicLog' extension for examples.
--
--
-- * NOTE: EwmhDesktops users should use the 'ewmh' function from
-- XMonad.Hooks.EwmhDesktops to modify their defaultConfig as a whole.
-- It will add EWMH logHook actions to your custom log hook by
-- combining it with ewmhDesktopsLogHook.
--

------------------------------------------------------------------------
-- Startup hook

-- Perform an arbitrary action each time xmonad starts or is restarted
-- with mod-q.  Used by, e.g., XMonad.Layout.PerWorkspace to initialize
-- per-workspace layout choices.
--
-- By default, do nothing.
--
-- * NOTE: EwmhDesktops users should use the 'ewmh' function from
-- XMonad.Hooks.EwmhDesktops to modify their defaultConfig as a whole.
-- It will add initialization of EWMH support to your custom startup
-- hook by combining it with ewmhDesktopsStartup.
--
myStartupHook = return ()

------------------------------------------------------------------------
-- Now run xmonad with all the defaults we set up.

-- Run xmonad with the settings you specify. No need to modify this.
--
main = do
    xmonadBar <- spawnPipe "xmobar ~/.xmobarrc_top"
    let myLogPP = defaultPP
                { ppCurrent = xmobarColor "#2ECC71" "#111111" . wrap "[" "]"
                , ppHidden = xmobarColor "#666666" "#111111"
                , ppUrgent = xmobarColor "#FF0000" "#111111"
                , ppLayout = xmobarColor "#E67E22" "#111111"
                , ppTitle = xmobarColor "#87FF00" "#111111" . shorten 150
                , ppSep = " "
                , ppOutput = hPutStrLn xmonadBar
                }
    let myLogHook = dynamicLogWithPP =<< workspaceNamesPP myLogPP
    xmonad $ ewmh $ docks $ defaultConfig {
        -- simple stuff
            terminal           = myTerminal,
            focusFollowsMouse  = myFocusFollowsMouse,
            borderWidth        = myBorderWidth,
            modMask            = myModMask,
            -- numlockMask deprecated in 0.9.1
            -- numlockMask        = myNumlockMask,
            workspaces         = myWorkspaces,
            normalBorderColor  = myNormalBorderColor,
            focusedBorderColor = myFocusedBorderColor,

        -- key bindings
            keys               = myKeys,
            mouseBindings      = myMouseBindings,

        -- hooks, layouts
            layoutHook         = myLayout,
            manageHook         = myManageHook,
            handleEventHook    = myEventHook,
            logHook            = myLogHook,
            startupHook        = myStartupHook
        }
