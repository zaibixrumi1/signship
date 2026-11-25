#!/bin/sh
# speed-test shim: this test repo cannot carry gradle/wrapper/gradle-wrapper.jar
# (binary files can't be pushed through the connector), so resolve the project's
# pinned Gradle 9.6.0 directly. Mirrors what the real wrapper does: use a local
# Gradle 9.6.0 if one is installed, otherwise download the distribution once.
if [ -x /opt/gradle-9.6.0/bin/gradle ]; then
  exec /opt/gradle-9.6.0/bin/gradle "$@"
fi
DIST_HOME="$HOME/.gradle-dist"
if [ ! -x "$DIST_HOME/gradle-9.6.0/bin/gradle" ]; then
  mkdir -p "$DIST_HOME"
  curl -fsSL https://services.gradle.org/distributions/gradle-9.6.0-bin.zip -o /tmp/gradle-9.6.0-bin.zip
  unzip -q /tmp/gradle-9.6.0-bin.zip -d "$DIST_HOME"
  rm -f /tmp/gradle-9.6.0-bin.zip
fi
exec "$DIST_HOME/gradle-9.6.0/bin/gradle" "$@"
