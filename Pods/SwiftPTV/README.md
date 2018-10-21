# SwiftPTV

[![CI Status](http://img.shields.io/travis/evilgoldfish/SwiftPTV.svg?style=flat)](https://travis-ci.org/evilgoldfish/SwiftPTV)
[![Version](https://img.shields.io/cocoapods/v/SwiftPTV.svg?style=flat)](http://cocoapods.org/pods/SwiftPTV)
[![License](https://img.shields.io/cocoapods/l/SwiftPTV.svg?style=flat)](http://cocoapods.org/pods/SwiftPTV)
[![Platform](https://img.shields.io/cocoapods/p/SwiftPTV.svg?style=flat)](http://cocoapods.org/pods/SwiftPTV)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

## Requirements

* An API key and user ID from PTV. You can get one from [here](https://static.ptv.vic.gov.au/PTV/PTV%20docs/API/1475462320/PTV-Timetable-API-key-and-signature-document.RTF).

## Installation

### CocoaPods

SwiftPTV is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'SwiftPTV'
```

### Carthage

SwiftPTV is also available through [Carthage](https://github.com/Carthage/Carthage). To install
it, add the following line to your Cartfile:

```
github "evilgoldfish/SwiftPTV"
```

Run `carthage update` to build the framework and drag the newly built `SwiftPTV.framework` into your Xcode project.

## Example

You can run the included example app by cloning the repository, opening `SwiftPTV.xcodeproj` and choosing the `SwiftPTVExampleiOS` scheme on the top left of the Xcode window.

## Author

* evilgoldfish

## License

SwiftPTV is available under the MIT license. See the LICENSE file for more info.

### Data License
The PTV Timetable API Data is licensed under a Creative Commons Attribution 4.0 International Licence. Data from Public Transport Victoria is not supplied with this framework, but using the PTV Timetable API Data requires the following attribution:

`Source: Licensed from Public Transport Victoria under a Creative Commons Attribution 4.0 International Licence.`

See the [PTV website](https://www.ptv.vic.gov.au/about-ptv/ptv-data-and-reports/digital-products/ptv-timetable-api/) for more information.
