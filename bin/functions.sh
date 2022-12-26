export-toml() {
  eval $(node "$SCUF_ROOT/scripts/tomlToEnv.js" "$1")
}

remote() {
  [ -z $SCUF_ENV ] && echo "Error: no workspace found." && exit 1
  [ -z $PUBLISH_HOST ] && echo "Error: no host found." && exit 1
  [[ $SCUF_ENV != "dev" ]] && echo "Error: remote call in a live workspace." && exit 1
  ssh -p "${PUBLISH_PORT:-22}" "${PUBLISH_USER:-$USER}@$PUBLISH_HOST" "$@"
}

mirror() {
  rsync --verbose --delete --archive --progress --checksum \
    --no-owner --no-perms --no-group --no-times \
    "$1" "$PUSH_SSH:$2" "${@:3}"
}

banner() {
  [ -z "$SCUF_ENV" ] && b0="" || b0="\u001b[38;5;240mWorkspace: \e[0;32m$SCUF_WS\e[0m"
  [ -z "$SCUF_ENV" ] && b1="" || b1="     \u001b[38;5;240mSite: \e[0;31m$SITE_NAME\e[0m"
  [ -z "$SCUF_ENV" ] && b2="" || b2="   \u001b[38;5;240mDomain: \e[0;35m$SITE_DOMAIN\e[0m"
  [ -z "$SCUF_ENV" ] && b3="" || b3="      \u001b[38;5;240mEnv: \e[0;32m$SCUF_ENV\e[0m"
  echo -e "┏━━┳━┳┳┳━━┓  $b0"
  echo -e "┃━━┫┏┫┃┃━┳┛  $b1"
  echo -e "┣━━┃┗┫┃┃┏┛   $b2"
  echo -e "┗━━┻━┻━┻┛    $b3\e[0m"
}

usage() {
  cat << EOF
Usage: scuf <command> [options]

  Commands:
    init <path>               Create new project
    exec <...>                Execute command in project environment
    compose <...>             Use docker-compose on project
    watch <service>           Watch container logs
    remote <...>              Issue remote command to published project
    cache <start|stop>        Start/stop package cache
  
  Options:
    -w, --workspace <path>    Path to workspace
    -h, --help                Show this help text

EOF
}
