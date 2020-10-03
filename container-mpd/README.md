# MPD

Music Player Daemon

* https://www.musicpd.org/doc/html/user.html

## plans

Future TODO plans

* use [liquidsoap](https://www.liquidsoap.info/) containers for High availability, and to add some radio station logic etc. Use stream silence detection to swap between MPD servers.
* feed MPD audio stream/s to a pool of [Icecast](https://icecast.org/) containers so we can scale out for more listeners.
* secondary MPD container for alternate stream.