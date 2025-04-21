{
  hostName,
  userName,
  ...
}: let
  icon_view_settings = {
    arrangeBy = "name";
    gridSpacing = 1.0;
    iconSize = 64.0;
    showItemInfo = true;
  };

  trackpad = {
    Clicking = 1;
    DragLock = 0;
    Dragging = 0;
    TrackpadCornerSecondaryClick = 0;
    TrackpadFiveFingerPinchGesture = 0;
    TrackpadFourFingerHorizSwipeGesture = 0;
    TrackpadFourFingerPinchGesture = 0;
    TrackpadFourFingerVertSwipeGesture = 0;
    TrackpadHandResting = 1;
    TrackpadHorizScroll = 1;
    TrackpadMomentumScroll = 1;
    TrackpadPinch = 1;
    TrackpadRightClick = 1;
    TrackpadRotate = 0;
    TrackpadScroll = 1;
    TrackpadThreeFingerDrag = 0;
    TrackpadThreeFingerHorizSwipeGesture = 0;
    TrackpadThreeFingerTapGesture = 2;
    TrackpadThreeFingerVertSwipeGesture = 0;
    TrackpadTwoFingerDoubleTapGesture = 0;
    TrackpadTwoFingerFromRightEdgeSwipeGesture = 0;
    USBMouseStopsTrackpad = 0;
    UserPreferences = 1;
  };
in {
  imports = [
    ./darwin/homebrew.nix
  ];

  environment.etc."sudoers.d/custom".text = ''
    Defaults env_keep += "TERMINFO"
    Defaults timestamp_timeout=-1
  '';

  networking = {
    computerName = hostName;
    inherit hostName;
  };

  system = {
    # Turn off NIX_PATH warnings now that we're using flakes
    checks.verifyNixPath = false;

    activationScripts.postUserActivation.text = ''
      # Following line should allow us to avoid a logout/login cycle
      /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
    '';

    defaults = {
      NSGlobalDomain = {
        "com.apple.sound.beep.volume" = 0.5;
        "com.apple.mouse.tapBehavior" = 1;
      };

      ActivityMonitor = {
        OpenMainWindow = true;
        ShowCategory = 101; # All Processes, Hierarchally
        SortColumn = "CPUUsage";
        SortDirection = 0; # Descending
      };

      dock = {
        # Set Dock to auto-hide and remove the auto-hiding delay.
        autohide = true;
        autohide-delay = 0.0;
        autohide-time-modifier = 0.0;

        # Wipe all (default) app icons from the Dock.
        persistent-apps = [];

        # Don’t show recent applications in Dock
        show-recents = false;

        # Show only open applications in the Dock
        static-only = true;

        # Setting the icon size of Dock items to 36 pixels for optimal size/screen-realestate
        tilesize = 48;

        # Turn off Spaces auto-switching
        # workspaces-auto-swoosh = false;

        wvous-bl-corner = 1;
        wvous-br-corner = 1;
        wvous-tl-corner = 1;
        wvous-tr-corner = 1;
      };

      finder = {
        # Finder > Preferences > Show warning before changing an extension
        FXEnableExtensionChangeWarning = false;

        # Finder > View > As List
        FXPreferredViewStyle = "Nlsv";

        # Show icons for hard drives, servers, and removable media on the desktop.
        ShowExternalHardDrivesOnDesktop = true;
        ShowRemovableMediaOnDesktop = true;
        ShowMountedServersOnDesktop = false;

        # Set ~ as the default location for new Finder windows
        NewWindowTarget = "Home";

        # When performing a search, search the current folder by default
        FXDefaultSearchScope = "SCcf";

        # Sort folders on top
        _FXSortFoldersFirst = false;
      };

      CustomUserPreferences = {
        NSGlobalDomain = {
          AppleEnableMenuBarTransparency = false;
          AppleShowScrollBars = "Always";

          # Make macOS react faster to keystrokes.
          KeyRepeat = 4;
          InitialKeyRepeat = 15;

          # Disable press-and-hold for keys in favor of key repeat
          ApplePressAndHoldEnabled = false;

          # Enabling full keyboard access for all controls (enable Tab in modal dialogs, menu windows, etc.)
          AppleKeyboardUIMode = 3;

          NSPersonNameDefaultDisplayNameOrder = 1; # First name first
          NSPersonNameDefaultShouldPreferNicknamesPreference = 1; # Prefer nicknames
          NSPersonNameDefaultShortNameEnabled = 1; # Short name only
          NSPersonNameDefaultShortNameFormat = 3;

          NSUseAnimatedFocusRing = false; # Disable the over-the-top focus ring animation

          # Disable animations when opening and closing windows.
          NSAutomaticWindowAnimationsEnabled = false;

          # Increase window resize speed for Cocoa applications
          NSWindowResizeTime = 0.001;

          # Disable animations when opening a Quick Look window.
          QLPanelAnimationDuration = 0;

          # Expanding the save & print panels by default.
          NSNavPanelExpandedStateForSaveMode = true;
          NSNavPanelExpandedStateForSaveMode2 = true;
          PMPrintingExpandedStateForPrint = true;
          PMPrintingExpandedStateForPrint2 = true;

          # Disable smart dashes as they’re annoying when typing code
          NSAutomaticDashSubstitutionEnabled = false;

          # Disable automatic period substitution as it’s annoying when typing code
          NSAutomaticPeriodSubstitutionEnabled = false;

          # Disable smart quotes as they’re annoying when typing code
          NSAutomaticQuoteSubstitutionEnabled = false;

          # Disable auto-correct
          NSAutomaticSpellingCorrectionEnabled = false;

          # Disable Capitalize words automatically
          NSAutomaticCapitalizationEnabled = false;

          # Adding a context menu item for showing the Web Inspector in web views
          WebKitDeveloperExtras = true;

          # Turn off auto-termination
          NSDisableAutomaticTermination = true;
        };

        "com.apple.Accessibility" = {
          EnhancedBackgroundContrastEnabled = true;
        };

        # "com.apple.AddressBook" = {
        #   ABBirthDayVisible = true;
        #   ABIncludeNotesInVCard = true; # Export notes in vCards
        #   ABIncludePhotosInVCard = true; # Export photos in vCards
        #   ABNameSortingFormat = "sortingFirstName sortingLastName";
        #   ABPrivateVCardFieldsEnabled = false; # Enable private me vCard
        #   ABUse21vCardFormat = false;
        # };

        "com.apple.assistant.support" = {
          # "disable" Enable Ask Siri
          "Assistant Enabled" = false;
        };

        "com.apple.desktopservices" = {
          # Avoid creating .DS_Store files on network or USB volumes
          DSDontWriteNetworkStores = true;
          DSDontWriteUSBStores = true;

          # Force the Finder to gather all metadata first
          UseBareEnumeration = 1;
        };

        "com.apple.AppleMultitouchTrackpad" = trackpad;
        "com.apple.driver.AppleBluetoothMultitouch.trackpad" = trackpad;

        # Disable Xcode Cloud up-sell
        "com.apple.dt.Xcode" = {
          XcodeCloudUpsellPromptEnabled = false;
        };

        "com.apple.finder" = {
          # Disable Finder animations.
          DisableAllAnimations = true;

          # Finder > Preferences > Show warning before removing from iCloud Drive
          FXEnableRemoveFromICloudDriveWarning = false;

          # Expand the following File Info panes: "General", "Open with", and "Sharing & Permissions"
          FXInfoPanesExpanded = {
            General = true;
            OpenWith = true;
            Privileges = true;
          };

          # Disable sidebar: Recent Tags
          ShowRecentTags = false;

          # Open folders in new Finder windows instead of tabs
          FinderSpawnTab = false;

          # Sort icon views by name, show item info and minimize grid spacing in icon views.
          "DesktopViewSettings.IconViewSettings" = icon_view_settings;
          "FK_StandardViewSettings.IconViewSettings" = icon_view_settings;
          "StandardViewSettings.IconViewSettings" = icon_view_settings;
        };

        "com.apple.iCal" = {
          "add holiday calendar" = true;
          "display birthdays calendar" = true;
          "first day of week" = 0;
          "first minute of work hours" = 480;
          "last minute of work hours" = 1020;
          "n days of week" = 7;
          "number of hours displayed" = 12;
          "scroll by weeks in week view" = 1;
          "Show heat map in Year View" = false;
          "Show time in Month View" = true;
          "Show Week Numbers" = false;
          "TimeZone support enabled" = true;
          CalendarSidebarShown = true;
          InvitationNotificationsDisabled = false;
          OpenEventsInWindowType = false;
          privacyPaneHasBeenAcknowledgedVersion = 4;
          SharedCalendarNotificationsDisabled = true;
          TimeToLeaveEnabled = true;
          WarnBeforeSendingInvitations = false;
        };

        # Enable AirDrop over Ethernet
        "com.apple.NetworkBrowser" = {
          BrowseAllInterfaces = true;
        };

        # Disable disk image verification.
        "com.apple.frameworks.diskimages" = {
          skip-verify = true;
          skip-verify-locked = true;
          skip-verify-remote = true;
        };

        "com.apple.Mail" = {
          # Copy email addresses as `foo@example.com` instead of `Foo Bar <foo@example.com>` in Mail.app
          AddressesIncludeNameOnPasteboard = false;

          # Sort conversations in descending order (recent on the top)
          ConversationViewSortDescending = true;

          # Disable send and reply animations in Mail.app
          DisableReplyAnimations = true;
          DisableSendAnimations = true;
        };

        # Disable auto correct and other substitutions in Message.app.
        "com.apple.messageshelper.MessageController" = {
          SOInputLineSettings = {
            automaticQuoteSubstitutionEnabled = false;
            automaticEmojiSubstitutionEnablediMessage = false; # spellchecker:disable-line
            continuousSpellCheckingEnabled = false;
          };
        };

        # Set Help Viewer windows to non-floating mode
        "com.apple.helpviewer" = {
          DevMode = true;
        };

        # Completely Disable Dashboard
        "com.apple.dashboard" = {
          dashboard-enabled-state = 1;
          mcx-disabled = 1;
        };

        # Automatically quit printer app once the print jobs complete
        "com.apple.print.PrintingPrefs" = {
          "Quit When Finished" = true;
        };

        "com.apple.safari" = {
          AlwaysRestoreSessionAtLaunch = 1;
          AutoFillCreditCardData = 0;
          AutoFillFromAddressBook = 0;
          AutoFillMiscellaneousForms = 0;
          AutoFillPasswords = 0;
          AutoOpenSafeDownloads = 1;
          BlockStoragePolicy = 2;
          BrowsingAssistantConsentState = 2;
          CloudTabsOnStartPageConsent = 1;
          Command1Through9SwitchesTabs = false;
          CommandClickMakesTabs = true;
          DefaultBrowserPromptingState3 = 4;
          DidActivateReaderAtleastOnce = 1;
          DidClearLegacySpotlightMetadataCaches = 1;
          DidFillFavoritesBarWithBuiltInBookmarks = 1;
          DidGrantSearchProviderAccessToWebNavigationExtensions = 1;
          DidMigrateAppExtensionPermissions = 1;
          DidMigrateDefaultsToSandboxSecureDefaults = 1;
          DidMigrateDownloadFolderToSandbox = 1;
          DidMigrateLastSessionPlist = 1;
          DidMigrateNewBookmarkSheetToReadingListDefault = 1;
          DidMigrateResourcesToSandbox = 1;
          DidMigrateSecureDefaultsToUserDefaults = 1;
          DidMigrateStartPageDefaultSidebarVisibility = 1;
          DidMigrateToCoreSpotlightBasedHistorySearch = 1;
          DidMigrateToMoreRestrictiveFileURLPolicy = 1;
          DidMigrateWebDriverAllowRemoteAutomation = 1;
          DidMigrateWebExtensionSQLiteStorageToWebKit = 1;
          DidRecomputeStartPageAppearanceAfterFixes = 1;
          DidReportHistorySettings = 1;
          DidShowWhatsNewInSafari18 = 1;
          DidUpdateCoreSpotlightBookmarksDataOnUpgrade = 1;
          # Remove downloads list items
          # 0 = manually
          # 1 = when safari quits
          # 2 = upon successful download
          # 3 = after on day
          DownloadsClearingPolicy = 0;
          EnableEnhancedPrivacyInRegularBrowsing = 1;
          EnableNarrowTabs = 0;
          ExcludePrivateWindowWhenRestoringSessionAtLaunch = 0;
          ExtensionsEnabled = 1;
          # Making Safari's search banners default to Contains instead of Starts With
          FindOnPageMatchesWordStartsOnly = false;
          HistoryAgeInDaysLimit = 365000;
          HomePage = "https://sully.org/dan/start/";
          IncludeDevelopMenu = 0;
          LastMinimumFontSize = 12;
          LocalFileRestrictionsEnabled = 0;
          NeverUseBackgroundColorInToolbar = 1;
          NewTabBehavior = 0;
          NewTabPageSetByUserGesture = 1;
          NewWindowBehavior = 0;
          OpenNewTabsInFront = false;
          OpenPrivateWindowWhenNotRestoringSessionAtLaunch = 0;
          PreloadTopHit = 0;
          PrintHeadersAndFooters = 0;
          PrivateBrowsingRequiresAuthentication = 1;
          PrivateSearchEngineUsesNormalSearchEngineToggle = 1;
          ReadingListSaveArticlesOfflineAutomatically = 1;
          SafariProfilesLastActiveProfileUUIDString = "DefaultProfile";
          SendDoNotTrackHTTPHeader = true;
          ShowBackgroundImageInFavorites = 0;
          ShowFavoritesBar = false;
          ShowFavoritesUnderSmartSearchField = 0;
          ShowFullURLInSmartSearchField = 1;
          ShowIconsInTabs = true;
          ShowOverlayStatusBar = 1;
          ShowSidebarInNewWindows = 0;
          ShowSidebarInTopSites = 0;
          SidebarTabGroupHeaderExpansionState = 1;
          SidebarViewModeIdentifier = 0;
          SkipLoadingEnabledAppExtensionsAtLaunch = 0;
          SkipLoadingEnabledContentBlockersAtLaunch = 0;
          SkipLoadingEnabledWebExtensionsAtLaunch = 0;
          UniversalSearchFeatureNotificationHasBeenDisplayed = 1;
          UseHTTPSOnly = 0;
          UserStyleSheetEnabled = 0;
          WBSOfflineSearchSuggestionsModelGoogleWasDefaultSearchEngineKey = 1;
          WBSOfflineSearchSuggestionsModelLastUsedLocaleIdentifierKey = "en_US";
          WBSPerSiteSettingSyncInitialSyncCompletedKey = 1;
          WebKitDefaultTextEncodingName = "utf-8";
          WebKitDeveloperExtrasEnabledPreferenceKey = 1;
          WebKitMinimumFontSize = 0;

          # Disable the standard delay in rendering a Web page.
          WebKitInitialTimedLayoutDelay = 0.25;
          WebKitResourceTimedLayoutDelay = 0.0001;

          "WebKitPreferences.allowFileAccessFromFileURLs" = 1;
          "WebKitPreferences.allowsPictureInPictureMediaPlayback" = 1;
          "WebKitPreferences.applePayEnabled" = 1;
          "WebKitPreferences.defaultTextEncodingName" = "utf-8";
          "WebKitPreferences.developerExtrasEnabled" = 1;
          "WebKitPreferences.hiddenPageDOMTimerThrottlingAutoIncreases" = 1;
          "WebKitPreferences.invisibleMediaAutoplayNotPermitted" = 1;
          "WebKitPreferences.javaScriptCanOpenWindowsAutomatically" = 1;
          "WebKitPreferences.minimumFontSize" = 0;
          "WebKitPreferences.needsStorageAccessFromFileURLsQuirk" = 0;
          "WebKitPreferences.pushAPIEnabled" = 1;
          "WebKitPreferences.shouldAllowUserInstalledFonts" = 0;
          "WebKitPreferences.shouldSuppressKeyboardInputDuringProvisionalNavigation" = 1;
          "WebKitPreferences.storageBlockingPolicy" = 1;
          "WebKitPreferences.universalAccessFromFileURLsAllowed" = 1;
          WebKitRespectStandardStyleKeyEquivalents = 1;
          WebKitStorageBlockingPolicy = 1;

          # Include Safari Suggestions
          UniversalSearchEnabled = false;
        };

        "com.apple.Security.Authorization" = {
          # Ignore ARD as the following discussion to fix the sudo with touch ID in the terminal:
          # https://apple.stackexchange.com/questions/411497/pam-tid-so-asks-for-password-instead-of-requesting-for-fingerprint-when-docked
          ignoreArd = true;
        };

        "com.apple.screencapture" = {
          location = "~/Library/Mobile Documents/com~apple~CloudDocs/Screenshots";
          type = "png";
        };

        "com.apple.Siri" = {
          ConfirmSiriInvokedViaEitherCmdTwice = 0;
          ContinuousSpellCheckingEnabled = 0;
          GrammarCheckingEnabled = 1;
          KeyboardShortcutPreSAE = {
            enabled = 0;
          };
          KeyboardShortcutSAE = {
            enabled = 0;
          };
          StatusMenuVisible = 0;
          VoiceTriggerUserEnabled = 0;
        };

        "com.apple.systemuiserver" = {
          "NSStatusItem Visible com.apple.menuextra.appleuser" = 0;
          "NSStatusItem Visible com.apple.menuextra.bluetooth" = 1;
          "NSStatusItem Visible com.apple.menuextra.clock" = 0;
          "NSStatusItem Visible com.apple.menuextra.volume" = 0;
          dontAutoLoad = [
            "/System/Library/CoreServices/Menu Extras/AirPort.menu"
            "/System/Library/CoreServices/Menu Extras/Clock.menu"
            "/System/Library/CoreServices/Menu Extras/Displays.menu"
            "/System/Library/CoreServices/Menu Extras/TimeMachine.menu"
            "/System/Library/CoreServices/Menu Extras/User.menu"
            "/System/Library/CoreServices/Menu Extras/Volume.menu"
            "/System/Library/CoreServices/Menu Extras/WWAN.menu"
          ];
        };

        "com.apple.SoftwareUpdate" = {
          # Check for software updates daily, not just once per week
          ScheduleFrequency = 1;

          # Download newly available updates in background
          AutomaticDownload = 1;

          # Install System data files & security updates
          CriticalUpdateInstall = 1;

          # Don't download apps purchased on other Macs
          ConfigDataInstall = 0;

          # Enable the automatic update check
          AutomaticCheckEnabled = true;
        };

        "com.apple.Spotlight" = {
          # Don't display first-time Spotlight messages
          showedFTE = 1;
          showedLearnMore = 1;
        };

        "com.apple.TextEdit" = {
          # Open and save files as UTF-8 in TextEdit
          PlainTextEncoding = 4;
          PlainTextEncodingForWrite = 4;

          # Use plain text mode for new TextEdit documents
          RichText = 0;
        };

        "com.apple.TextInputMenu" = {
          visible = false; # Disable the flag / keyboard icon.
        };

        "com.apple.TimeMachine".DoNotOfferNewDisksForBackup = true;

        # Turn on app auto-update
        "com.apple.commerce".AutoUpdate = true;

        "com.google.Chrome" = {
          # Use the system-native print preview dialog
          DisablePrintPreview = true;

          # Expand the print dialog by default
          PMPrintingExpandedStateForPrint2 = true;

          # https://support.google.com/chrome/thread/14193532?hl=en
          ExternalProtocolDialogShowAlwaysOpenCheckbox = true;
        };

        "com.google.Chrome.canary" = {
          PMPrintingExpandedStateForPrint2 = true;
          DisablePrintPreview = true;
        };

        "net.matthewpalmer.Rocket" = {
          "deactivated-apps" = [
            "Slack"
            "Xcode"
            "Terminal"
            "Quicken"
            "Code"
            "Finder"
            "Raycast"
            "Ghostty"
            "Screens 5"
            "Safari"
            "Google Chrome"
            "ChatGPT"
            "BoltAI"
            "Zed"
          ];
          "hot-key-b8-iaK-thyib-yoV-Kep-It" = ":";
          "launch-at-login" = 1;
        };
      };

      LaunchServices = {
        LSQuarantine = false;
      };

      smb.NetBIOSName = hostName;
    };

    keyboard = {
      enableKeyMapping = true;
      remapCapsLockToControl = true;
    };
  };

  security.pam.services.sudo_local = {
    touchIdAuth = true;
    reattach = true;
  };

  # The user should already exist, but we need to set this up so Nix knows
  # what our home directory is (https://github.com/LnL7/nix-darwin/issues/423).
  # users.users.dsully = {
  #   home = "/Users/dsully";
  #   shell = pkgs.fish;
  #   ignoreShellProgramCheck = true;
  # };

  users.users.${userName}.home = "/Users/${userName}";
}
