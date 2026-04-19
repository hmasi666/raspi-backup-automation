#!/usr/bin/env bash

set -euo pipefail

# ----------------------------
# Configuration
# ----------------------------

REMOTE_USER="youruser"
REMOTE_HOST="example.com"
REMOTE_PORT="22"

REMOTE_BASE_DIR="/path/to/backup/storage"
SNAPSHOT_NAME="$(date +%F_%H-%M-%S)"
REMOTE_SNAPSHOT_DIR="${REMOTE_BASE_DIR}/snapshots/${SNAPSHOT_NAME}"
REMOTE_LATEST_LINK="${REMOTE_BASE_DIR}/latest"

LOCAL_SOURCE_DIR="/path/to/local/server-data"

RETENTION_COUNT=5

MAIL_TO="your@email.com"
MAIL_SUBJECT_SUCCESS="Raspberry Pi backup succeeded"
MAIL_SUBJECT_FAILURE="Raspberry Pi backup failed"

# ----------------------------
# Helper functions
# ----------------------------

log() {
    printf '%s\n' "$1"
}

send_success_mail() {
    command -v mail >/dev/null 2>&1 || return 0

    printf 'Backup completed successfully: %s\n' "${REMOTE_SNAPSHOT_DIR}" | \
        mail -s "${MAIL_SUBJECT_SUCCESS}" "${MAIL_TO}"
}

send_failure_mail() {
    command -v mail >/dev/null 2>&1 || return 0

    printf 'Backup failed while processing snapshot: %s\n' "${REMOTE_SNAPSHOT_DIR}" | \
        mail -s "${MAIL_SUBJECT_FAILURE}" "${MAIL_TO}"
}

cleanup_old_snapshots() {
    ssh -p "${REMOTE_PORT}" "${REMOTE_USER}@${REMOTE_HOST}" "
        set -e
        cd '${REMOTE_BASE_DIR}/snapshots'
        ls -1dt */ 2>/dev/null | tail -n +$((RETENTION_COUNT + 1)) | xargs -r rm -rf
    "
}

on_error() {
    log '❌ Backup failed.'
    send_failure_mail
}

trap on_error ERR

# ----------------------------
# Backup workflow
# ----------------------------

log '🔍 Checking SSH connectivity...'
ssh -p "${REMOTE_PORT}" -o BatchMode=yes -o ConnectTimeout=10 \
    "${REMOTE_USER}@${REMOTE_HOST}" "echo connected" >/dev/null

log '📁 Creating remote snapshot directory...'
ssh -p "${REMOTE_PORT}" "${REMOTE_USER}@${REMOTE_HOST}" \
    "mkdir -p '${REMOTE_SNAPSHOT_DIR}' '${REMOTE_BASE_DIR}/snapshots'"

log '📦 Transferring backup data over SSH...'
rsync -a --delete -e "ssh -p ${REMOTE_PORT}" \
    "${LOCAL_SOURCE_DIR}/" \
    "${REMOTE_USER}@${REMOTE_HOST}:${REMOTE_SNAPSHOT_DIR}/"

log '🔗 Updating latest symlink...'
ssh -p "${REMOTE_PORT}" "${REMOTE_USER}@${REMOTE_HOST}" \
    "ln -sfn '${REMOTE_SNAPSHOT_DIR}' '${REMOTE_LATEST_LINK}'"

log "🧹 Removing old snapshots, keeping latest ${RETENTION_COUNT}..."
cleanup_old_snapshots

log "✅ Backup completed: ${REMOTE_SNAPSHOT_DIR}"
send_success_mail
