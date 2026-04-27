######################################
# CHECK IF REBOOT IS REQUIRED
######################################

checkreboot() {
  printf "${BOLD}${LBLUE}::${RESET} ${BOLD}Checking libraries...${REGULAR}\n"
  local reboot_required=0

  local libs_and_pkgs=$(
    grep -H "lib.*(deleted)" /proc/*/maps 2>/dev/null |
    awk -F: '
      {
        split($1, a, "/")
        pid = a[3]
        match($0, /\/[^ ]*lib[^ ]+/)
        if (pid && RSTART) {
          lib = substr($0, RSTART, RLENGTH)
          print pid, lib
        }
      }
    ' |
    sort -u |
    while read -r pid lib; do
      [[ -r /proc/$pid/comm ]] || continue
      cmd=$(<"/proc/$pid/comm")
      printf "%s|%s\n" "$cmd" "$lib"
    done
  )

  local unique_libs
  unique_libs=$(awk -F'|' '{print $2}' <<< "$libs_and_pkgs" | sort -u)

  if [[ -n $unique_libs ]]; then
    echo -e "${BYELLOW} the following libraries require a reboot:${RESET}"
    while read -r lib; do
      echo "    $lib (deleted)"
    done <<< "$unique_libs"

    echo
    echo -e "${BYELLOW} affected packages:${RESET}"
    awk -F'|' '{print $1}' <<< "$libs_and_pkgs" | sort -u | column
    echo

    reboot_required=1
  else
    echo -e "${RESET} no running programs affected${RESET}"
  fi

  printf "${BOLD}${LBLUE}::${RESET} ${BOLD}Checking kernel...${REGULAR}\n"

  if command -v pacman >/dev/null; then
    local active_kernel=$(uname -r | tr '-' '.')
    local current_kernel=$(pacman -Q | grep '^linux' | awk '{print $2}' | sort -V | tail -n1)
    current_kernel=${current_kernel//-/.}

    if [[ "$active_kernel" != "$current_kernel" ]]; then
      echo "Kernel mismatch: $active_kernel vs $current_kernel"
      reboot_required=1
    else
      echo "Kernel is up to date"
    fi

  elif command -v dpkg >/dev/null; then
    if [[ -f /var/run/reboot-required ]]; then
      echo "Reboot required"
      reboot_required=1
    else
      echo "Kernel is up to date"
    fi
  fi

  (( reboot_required == 0 )) && return 0 || return 1
}

######################################
# LAST UPDATE TRACKER
######################################

lastupdate() {
  local stamp_file="$HOME/.last_update"
  local now=$(date +%s)

  if [[ -f "$stamp_file" ]]; then
    local last=$(<"$stamp_file")

    if [[ "$last" =~ ^[0-9]+$ ]]; then
      local diff=$((now - last))
      local days=$((diff / 86400))
      local hours=$(((diff % 86400) / 3600))
      local minutes=$(((diff % 3600) / 60))

      printf "${BOLD}${LBLUE}::${RESET} Last update: "
      date -d "@$last" "+%Y-%m-%d %H:%M:%S"

      echo " (${days}d ${hours}h ${minutes}m ago)"
    fi
  else
    echo "No previous update timestamp found."
  fi

  date +%s > "$stamp_file"
}
