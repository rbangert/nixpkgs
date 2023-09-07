with import <nixpkgs> { };

rustPlatform.buildRustPackage rec {
  pname = "swhkd";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "waycrate";
    repo = pname;
    rev = "version";
    hash = "sha256-6kTRAUP///EwIkF1QkQByHqHW55u2L2Gv3c+B5z3e5U=";
  };

  cargoHash = lib.fakeHash;

  cargoLock = {
    lockFile = ../../Cargo.lock;
  };

  nativeBuildInputs = [
    makeWrapper
    rustc
    rustup
    scdoc
    udev
    pkg-config
  ];

  buildInputs = [ polkit ];

  postInstall = ''
    cp ${./swhkd.service} ./swhkd.service

    cp ${./hotkeys.sh} ./hotkeys.sh
    chmod +x ./hotkeys.sh

    install -D -m0444 -t "$out/lib/systemd/user" ./swhkd.service
    install -D -m0444 -t "$out/share/swhkd" ./hotkeys.sh
    install -D -m0444 -t "$out/share/polkit-1/actions" ./com.github.swhkd.pkexec.policy

    chmod +x "$out/share/swhkd/hotkeys.sh"

    substituteInPlace "$out/share/swhkd/hotkeys.sh" \
    --replace @runtimeShell@ "${runtimeShell}" \
    --replace @psmisc@ "${psmisc}" \
    --replace @out@ "$out"

    substituteInPlace "$out/lib/systemd/user/swhkd.service" \
    --replace @out@ "$out/share/swhkd/hotkeys.sh"

    substituteInPlace "$out/share/polkit-1/actions/com.github.swhkd.pkexec.policy" \
    --replace /usr/bin/swhkd \
    "$out/bin/swhkd"
  '';

  meta = with lib; {
    description = "The Simple Wayland Hotkey Daemon";
    homepage = "https://git.sr.ht/~shinyzenith/swhk";
    license = licenses.bsd2;
    platforms = platforms.linux;
  };
}
