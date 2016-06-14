# FloatingHintTextField

[![CI Status](http://img.shields.io/travis/Pereiro, Delfin/FloatingHintTextField.svg?style=flat)](https://travis-ci.org/Pereiro, Delfin/FloatingHintTextField)
[![Version](https://img.shields.io/cocoapods/v/FloatingHintTextField.svg?style=flat)](http://cocoapods.org/pods/FloatingHintTextField)
[![License](https://img.shields.io/cocoapods/l/FloatingHintTextField.svg?style=flat)](http://cocoapods.org/pods/FloatingHintTextField)
[![Platform](https://img.shields.io/cocoapods/p/FloatingHintTextField.svg?style=flat)](http://cocoapods.org/pods/FloatingHintTextField)


## Overview
FloatingHintTextField is a subclass of UITextField, written in Swift, and another implementation of the UX pattern known as the "Float Label Pattern". It allows to keep the placeholder "label" even when 

## Requirements
* ARC
* iOS8

## Installation

#### CocoaPods

FloatingHintTextField is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "FloatingHintTextField"
```

#### Manual

Simply download the latest files from the [Releases page](https://github.com/KuroBCN/FloatingHintTextfield/releases) and add the FloatingHintTextField.swift class to your project.

## Usage

```Swift
import FloatingHintTextField

let  floatingHintTextField = FloatingHintTextField.init(frame: CGRectMake(20,200, 200, 40))
floatingHintTextField.placeholder = "Placeholder text"
self.view.addSubview(floatingHintTextField)

```

## Example Project

An example project is included with this repo.  To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Author

Delfin Pereiro Parejo

## License

FloatingHintTextField is available under the MIT license. See the LICENSE file for more info.
