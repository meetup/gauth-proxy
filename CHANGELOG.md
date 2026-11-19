# Change Log
All notable changes to this project will
be documented in this file.

## [Unreleased]
### Changed
- Rebuilt on the official nginx 1.30.7 image to fix CVE-2026-123634 (Lua module
  and OAuth scripts are now built and vendored in this repository).

### Added
- Redirect for non http.
- Proxy to something else.
