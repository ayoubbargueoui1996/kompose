#!/usr/bin/env bash
if [ ! -z "$WORKDIR" ]; then
	cd "$WORKDIR"
fi
exec sudo -u "#${USERID}" -g "#${GROUPID}" kompose "$@"
