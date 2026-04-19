# raspi-backup-automation

Automated backup workflow for a Raspberry Pi server with snapshot rotation and status notifications.

## Overview

This repository documents a practical backup automation setup used for a Raspberry Pi server environment.

The goal of the project is to create repeatable backup snapshots, keep only a defined number of recent backups, and provide clear success or failure feedback after each run.

## Current Workflow

The backup process includes the following steps:

* verify SSH connectivity to the backup target
* create the destination directory if needed
* transfer the server backup over SSH
* update a `latest` symlink to point to the newest snapshot
* remove older snapshots and keep only the most recent ones
* send a status notification after the job finishes

## Features

* automated server backup over SSH
* snapshot-based backup structure
* rotation logic for old backups
* latest-snapshot symlink for quick access
* success/failure notification support
* practical design for home server or lab use

## Goals

* automate recurring Raspberry Pi server backups
* reduce manual maintenance work
* make rollback and snapshot access easier
* create a reusable backup workflow for self-hosted environments
* document the setup in public portfolio form

## Environment

* Raspberry Pi
* Linux shell scripting
* SSH
* remote storage target
* email notifications

## Notes

This repository is based on a real backup workflow adapted into a public example.

AI tools (ChatGPT) were used for idea exploration, script refinement, debugging, and documentation support. The final workflow was tested and adjusted manually in a real environment.

Sensitive information such as real usernames, hostnames, paths, and addresses has been removed from this public version.

## Repository Structure

- `scripts/` – backup automation scripts
- `examples/` – example outputs and notifications
- `docs/` – project notes and documentation

