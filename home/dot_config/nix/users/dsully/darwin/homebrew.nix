{
  system.activationScripts.preUserActivation.text = ''
    if ! xcode-select --version 2>/dev/null; then
      run xcode-select --install
    fi

    if ! /opt/homebrew/bin/brew --version 2>/dev/null; then
      run /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
  '';

  homebrew = {
    enable = true;

    # Don't quarantine apps installed by homebrew with gatekeeper
    caskArgs.no_quarantine = true;

    onActivation = {
      autoUpdate = true;
      cleanup = "zap";
      extraFlags = [
        "--force"
      ];
      upgrade = true;
    };

    brews = [
      "lume"
      "mas"
    ];

    casks = [
      "1password"
      "1password-cli"
      "adguard"
      "android-platform-tools"
      "anylist"
      "backblaze"
      "boltai"
      "chatgpt"
      "cleanshot"
      "daisydisk"
      "discord"
      "downie"
      "fastmate"
      "fission"
      "font-jetbrains-mono"
      "font-monaspace"
      "ghostty"
      "google-chrome"
      "iina"
      "insta360-studio"
      "jordanbaird-ice"
      "keka"
      "latest"
      "lm-studio"
      "lunar"
      "macdive"
      "mist"
      "monodraw"
      "mullvadvpn"
      "ogdesign-eagle"
      "orion"
      "powerflow"
      "protonvpn"
      "proxyman"
      "quicken"
      "quickrecorder"
      "raindropio"
      "rapidapi"
      "raycast"
      "renamer"
      "retrobatch"
      "rio"
      "rocket"
      "signal"
      "soulseek"
      "soulver"
      "superduper"
      "suspicious-package"
      "syncthing"
      "tableplus"
      "tailscale"
      "telegram"
      "textsniper"
      "tower"
      "transmit"
      "whatsapp"
      "zed"
      "zipic"
    ];

    # Applications to install from Mac App Store using mas.
    # You need to install all these Apps manually first so that your apple account have records for them.
    # otherwise Apple Store will refuse to install them.
    # For details, see https://github.com/mas-cli/mas
    masApps = {
      "1Password for Safari" = 1569813296;
      "Acidity" = 6472630023;
      "AirPlayable" = 6475483628;
      "AllMyBatteries" = 1621263412;
      "Amphetamine" = 937984704;
      "Anybox" = 1593408455;
      "AutoMounter" = 1160435653;
      "AVR Control" = 1059512196;
      "Black Out" = 1319884285;
      "Bonjourr Startpage" = 1615431236;
      "Book Tracker" = 1496543317;
      "Brother P-touch Editor" = 1453365242;
      "CleanMyKeyboard" = 6468120888;
      "Color Picker" = 1545870783;
      "CotEditor" = 1024640650;
      "Croissant" = 6670288979;
      "Dark Noise" = 1465439395;
      "Darkroom" = 953286746;
      "Dato" = 1470584107;
      "DevCleaner" = 1388020431;
      "Discovery" = 1381004916;
      "DoubleMemory" = 6737529034;
      "Draw Things" = 6444050820;
      "File Icons for GitHub and GitLab" = 1631366167;
      "FilmNoir" = 1528417240;
      "Flighty" = 1358823008;
      "Globetrotter" = 6469319235;
      "GoPro Quik" = 561350520;
      "Hush" = 1544743900;
      "Hyperduck" = 6444667067;
      "Hyperspace" = 6739505345;
      "Infuse" = 1136220934;
      "iPreview" = 1519213509;
      "Ivory" = 6444602274;
      "JSONPeep" = 1458969831;
      "Kagi Search" = 1622835804;
      "Little Snitch Mini" = 1629008763;
      "Marked 2" = 890031187;
      "Mela" = 1568924476;
      "MetaImage" = 1397099749;
      "Paprika Recipe Manager 3" = 1303222628;
      "Parcel" = 639968404;
      "Patterns" = 429449079;
      "PDF Expert" = 1055273043;
      "Picview" = 6452016140;
      "Play" = 1596506190;
      "Prime Video" = 545519333;
      "Protego" = 6737959724;
      "QR Studio" = 6740007834;
      "Radiance" = 1573366225;
      "Reeder" = 1529448980;
      "Refined GitHub" = 1519867270;
      "Rules" = 6461118886;
      "Save to Raindrop.io" = 1549370672;
      "Screens 5" = 1663047912;
      "SD Gallery" = 6445901857;
      "Secret Inbox" = 6462335670;
      "ServerCat" = 1501532023;
      "Sink It" = 6449873635;
      "Slack" = 803453959;
      "SmugMug" = 1115348888;
      "Sogni" = 6450021857;
      "Sortio" = 6737292062;
      "Starship" = 1530665887;
      "StopTheMadness Pro" = 6471380298;
      "Subscriptions" = 1577082754;
      "TabDirector" = 6502719125;
      "Tampermonkey" = 6738342400;
      "Taska" = 6741809383;
      "TestFlight" = 899247664;
      "Text Lens" = 6743369285;
      # "Toast" = 1465707487;
      "TrashMe 3" = 1490879410;
      "Tripsy" = 1429967544;
      "Tuneful" = 6739804295;
      "UnTrap" = 1637438059;
      "Userscripts" = 1463298887;
      "WiFi Signal" = 525912054;
      "Wipr" = 1662217862;
      "WordService" = 899972312;
      "Yoink" = 457622435;
      "Zero Loss Compress" = 6738362427;
    };

    taps = [
      "homebrew/bundle"
      "homebrew/services"
      "lihaoyun6/tap" # quickrecorder
      "lzt1008/powerflow"
      "rajiv/fastmate"
    ];
  };
}
