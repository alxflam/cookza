# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]


## [0.0.32] - 2021-12-26
### Updated
- Updated Flutter to 2.8

### Fixed
- Comma decimal separator in ingredient amounts
- Incorrect date and calendar week calculation on the day the daylight savings time ends
- Enabled validation for input fields of ingredient creation
- Date range does not update in shopping list dialog for multiple meal plan groups
- Amount conversion for metric units of the same base unit may result in infinite loop, causing the shopping list to never load

### Changed
- Performance improvement for Leftover Reuse screen 

## [0.0.28] - 2021-08-24
### Fixed
- QR Code Scanning using camera live feed did not work on some devices
