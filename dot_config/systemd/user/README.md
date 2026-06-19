# ~/.config/systemd/user — user-level services

Services here run after login, under the user session.

## Services

### opendeck.service
Starts OpenDeck at `graphical-session.target` (after Wayland session is up).
Symlinked in `graphical-session.target.wants/`.

**Depends on system service:** requires `/dev/hidraw*` permissions set by
`ajazz-hidraw-fix.service` in `/etc/systemd/system/` — which runs at boot as root,
before login. See `~/etcfiles/systemd/system/README.md`.

### syncthing.service
Symlink to `/usr/lib/systemd/user/syncthing.service` (provided by package).
Enabled in `default.target.wants/`.

## Related system services

`~/etcfiles/systemd/system/` contains services that must run as root before login:
- `ajazz-hidraw-fix.service` — hidraw permissions for Ajazz AKP03 (required by opendeck)
- `wol.service` — Wake-on-LAN on `enp133s0`

Managed via `chezetc`. Deploy with `chezetc apply`.
