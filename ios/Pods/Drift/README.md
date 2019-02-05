Drift
============
[![CocoaPods](https://img.shields.io/cocoapods/v/Drift.svg)](https://github.com/Driftt/drift-sdk-ios)

DriftSDK is the official Drift SDK written in Swift enabling you to both send announcements and collect vital NPS responses all within the app!


# Features:
- Send Product announcements to your customers
- Create conversations from your app
- View past conversations from your app.


# Getting Setup

## Installation
DriftSDK can be added to your project using CocoaPods by adding the following line to your `Podfile`:

```ruby
pod 'Drift', '~> 2.2.7'
```

## Registering

To get started with the Drift iOS SDK you need an embed ID from your Drift settings page. This can be accessed [here](https://app.drift.com/settings/livechat) by looking after the drift.load method in the Javascript SDK.

In your AppDelegate `didFinishLaunchingWithOptions` call:
```Swift
  Drift.setup("")
```

or in ObjC
```objectivec
  [Drift setup:@""];
```

Once your user has successfully logged into the app registering a user with the device is done by calling register user with a unique identifier, typically the id from your database, and their email address:

```Swift
  Drift.registerUser("", email: "")
```
or in ObjC
```objectivec
  [Drift registerUser:@"" email:@""];
```

When your user logs out simply call logout so they stop receiving campaigns.

```Swift
  Drift.logout()
```

or in ObjC

```objectivec
  [Drift logout];
```

Thats it. Your good to go!!

# Archived Campaigns

Once a campaign is delivered to a user it will keep showing to a user until it is dismissed or completed. This happens even when the campaign is inactive or archived. If you would like to only show active campaign you can enable this by passing false to showArchivedCampaignsForEndUser during setup

```Swift
  Drift.showArchivedCampaignsForEndUser(false)
```

or in ObjC

```objectivec
  [Drift showArchivedCampaignsForEndUser:NO];
```


# Messaging

A user can begin a conversation in response to a campaign or by presenting the conversations list

```Swift
  Drift.showConversations()
```

or in ObjC

```objectivec
  [Drift showConversations];
```

You can also go directly to create a conversation using

```Swift
  Drift.showCreateConversation()
```

or in ObjC

```objectivec
  [Drift showCreateConversation];
```

Thats it. Your good to go!!


# Contributing

Contributions are very welcome 🤘.
