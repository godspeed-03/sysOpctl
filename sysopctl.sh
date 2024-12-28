#!/bin/bash

VERSION="v0.1.0"

function print_help() {
  echo "Usage: sysopctl [command] [arguments]"
  echo ""
  echo "Commands:"
  echo "  service          Manage system services"
  echo "    list           List all running services"
  echo "    start <name>   Start a service"
  echo "    stop <name>    Stop a service"
  echo "  system           View system load"
  echo "    load           Show system load averages"
  echo "  disk             Show disk usage"
  echo "    usage          Show disk usage by partition"
  echo "  process          Monitor system processes"
  echo "    monitor        Display real-time process activity"
  echo "  logs             Analyze system logs"
  echo "    analyze        Display recent critical log entries"
  echo "  backup           Backup system files"
  echo "    <path>         Backup the specified path"
  echo "  --version        Show version"
  echo "  --help           Show this help message"
}

function print_version() {
  echo "sysopctl version $VERSION"
}

function service_list() {
  echo "Listing all active services:"
  systemctl list-units --type=service
}

function service_start() {
  echo "Starting service: $1"
  systemctl start $1
}

function service_stop() {
  echo "Stopping service: $1"
  systemctl stop $1
}

function system_load() {
  echo "System load averages:"
  uptime | awk '{print "Load Averages: " $3 " " $4 " " $5}'
}

function disk_usage() {
  echo "Disk usage by partition:"
  df -h
}

function process_monitor() {
  echo "Monitoring system processes (press q to quit):"
  top
}

function logs_analyze() {
  echo "Analyzing recent critical system logs:"
  journalctl -p 3 -n 20 --no-pager
}

function backup_files() {
  echo "Backing up files from $1..."
  rsync -av --progress $1 /backup_location
  echo "Backup completed."
}

# Command handler
if [[ "$1" == "--help" ]]; then
  print_help
  exit 0
elif [[ "$1" == "--version" ]]; then
  print_version
  exit 0
elif [[ "$1" == "service" ]]; then
  if [[ "$2" == "list" ]]; then
    service_list
  elif [[ "$2" == "start" ]]; then
    service_start $3
  elif [[ "$2" == "stop" ]]; then
    service_stop $3
  else
    print_help
  fi
elif [[ "$1" == "system" && "$2" == "load" ]]; then
  system_load
elif [[ "$1" == "disk" && "$2" == "usage" ]]; then
  disk_usage
elif [[ "$1" == "process" && "$2" == "monitor" ]]; then
  process_monitor
elif [[ "$1" == "logs" && "$2" == "analyze" ]]; then
  logs_analyze
elif [[ "$1" == "backup" ]]; then
  backup_files $2
else
  print_help
fi
