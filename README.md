# AlamofireSafariLogger - a lightweight Alamofire call debugger

[![CI Status](http://img.shields.io/travis/rudolphwong2002@gmail.com/AlamofireSafariLogger.svg?style=flat)](https://travis-ci.org/rudolphwong2002@gmail.com/AlamofireSafariLogger)
[![Version](https://img.shields.io/cocoapods/v/AlamofireSafariLogger.svg?style=flat)](http://cocoapods.org/pods/AlamofireSafariLogger)
[![License](https://img.shields.io/cocoapods/l/AlamofireSafariLogger.svg?style=flat)](http://cocoapods.org/pods/AlamofireSafariLogger)
[![Platform](https://img.shields.io/cocoapods/p/AlamofireSafariLogger.svg?style=flat)](http://cocoapods.org/pods/AlamofireSafariLogger)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

- iOS 8.0+
- Xcode 8.0+
- Swift 3.2+

## Usage
This project is inspired by AlamofireNetworkActivityLogger and facebook Stetho library.
Reference:
https://github.com/konkab/AlamofireNetworkActivityLogger
https://github.com/facebook/stetho

The aim of this project is to log the Alamofire request and response to the Safari Web Inspector. By console log method in javascript, header and body is logged in console tab.

Console Log : Header
Console Warn: Body
Console Error:Error

Import the library:

```swift
import AlamofireSafariLogger
```

Add the following code to `AppDelegate.swift application:didFinishLaunchingWithOptions:`:

```swift
AlamofireSafariLogger.shared.startLogging()
```

### Open Safari , enable developer menu.
### Open web inspector in developer menu when your app is running.

![Example Image](https://raw.githubusercontent.com/springwong/AlamofireSafariLogger/master/example.png)

#!!!Remember to prevent library's execution in your production app#

## Features
isGroupCollapse - collapse log group in default
### Option for logging content:
isLogRequestHeader
isLogRequestBody
isLogResponseHeader 
isLogResponseBody
isLogError
isDisableLog - Disable all logging

## Installation

AlamofireSafariLogger is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'AlamofireSafariLogger'
```

## Author

rudolphwong2002@gmail.com

## License

AlamofireSafariLogger is available under the MIT license. See the LICENSE file for more info.
