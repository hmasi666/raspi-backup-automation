# Project Notes

## Purpose

This project was created to automate backups for a Raspberry Pi server environment.

The goal was to reduce manual work, improve reliability, and ensure that recent backup snapshots are always available in case of failure or data loss.

## What I learned

During this project I learned more about:

- automating system tasks using shell scripting
- using rsync over SSH for efficient data transfer
- structuring backup snapshots with timestamp-based naming
- implementing retention policies to manage storage usage
- handling errors and ensuring reliable execution
- adding simple notification mechanisms for monitoring

## Practical lessons

One key observation was that manual backups are easy to forget or delay.

By automating the process, backups become:

- consistent
- predictable
- easier to monitor

Another important lesson was the value of keeping a limited number of snapshots instead of storing everything indefinitely.

This improves both storage efficiency and clarity when restoring data.

## Portfolio note

This repository is based on a real backup workflow adapted into a public example.

Sensitive details such as real paths, hostnames, and credentials have been removed.

AI tools were used during development for ideation, debugging, and documentation, but the workflow was tested and validated manually in a real environment.
