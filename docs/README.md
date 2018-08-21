<p align="center"><img src="README-images/logo.png"/></p>

[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

## About

The SRG Diagnostics library is a set of lightweight components for collecting various application data for diagnostics purposes. The library is based on two main types of components:

* Reports, for collecting data.
* Services, responsible of report submission.

Reports and services are referenced by name and lazily created when accessed first. This makes it possible to create, fill and submit reports in a decentralized way. Note that diagnostics reports are not considered critical and are therefore not persisted between application sessions. You must never use such reports to convey data you cannot afford to lose.

## Compatibility

The library is suitable for applications running on iOS 9 and above. The project is meant to be opened with the latest Xcode version (currently Xcode 9).

## Installation

The library can be added to a project using [Carthage](https://github.com/Carthage/Carthage) by adding the following dependency to your `Cartfile`:
    
```
github "SRGSSR/srgdiagnostics-ios"
```

Until Carthage 0.30, only dynamic frameworks could be integrated. Starting with Carthage 0.30, though, frameworks can be integrated statically as well, which avoids slow application startups usually associated with the use of too many dynamic frameworks.

For more information about Carthage and its use, refer to the [official documentation](https://github.com/Carthage/Carthage).

### Dependencies

The library requires the following frameworks to be added to any target requiring it:

* `SRGDiagnostics`: The main library framework.

### Dynamic framework integration

1. Run `carthage update` to update the dependencies (which is equivalent to `carthage update --configuration Release`). 
2. Add the frameworks listed above and generated in the `Carthage/Build/iOS` folder to your target _Embedded binaries_.

If your target is building an application, a few more steps are required:

1. Add a _Run script_ build phase to your target, with `/usr/local/bin/carthage copy-frameworks` as command.
2. Add each of the required frameworks above as input file `$(SRCROOT)/Carthage/Build/iOS/FrameworkName.framework`.

### Static framework integration

1. Run `carthage update --configuration Release-static` to update the dependencies. 
2. Add the frameworks listed above and generated in the `Carthage/Build/iOS/Static` folder to the _Linked frameworks and libraries_ list of your target.
3. Also add any resource bundle `.bundle` found within the `.framework` folders to your target directly.
4. Add the `-all_load` flag to your target _Other linker flags_.

## Usage

When you want to use classes or functions provided by the library in your code, you must import it from your source files first.

### Usage from Objective-C source files

Import the global header file using:

```objective-c
#import <SRGDiagnostics/SRGDiagnostics.h>
```

or directly import the module itself:

```objective-c
@import SRGDiagnostics;
```

### Usage from Swift source files

Import the module where needed:

```swift
import SRGDiagnostics
```

### Creating reports

To create a report, pick appropriate service and report names first. For example, to collect playback metrics associated with playback of medias, we could use _playback_ as service name, and create a report for each media being played based on its identifier:

```objective-c
SRGDiagnosticsReport *report = [[SRGDiagnosticsService serviceWithName:@"playback"] reportWithName:@"1-23456-789"];
```

Report information is filled using `-set...:forKey:` methods:

```objective-c
[report setInteger:3000 forKey:@"kbps"];
[report setString:@"HD" forKey:@"quality"];
```

Time measurements (in milliseconds) can be easily added to a report. For example, to start a measurement saved under the `buffering` key, call:

```objective-c
[report startTimeMeasurementForKey:@"buffering"];
```

and to stop the measurement, call:

```objective-c
[report stopTimeMeasurementForKey:@"buffering"];
```

Information can be nested in a report. We could for example imagine saving network-related information together:

```objective-c
SRGDiagnosticInformation *information = [report informationForKey:@"network"];
[information setString:@"wifi" forKey:@"connection"];
[information setString:@"good" forKey:@"signal"];
```

Finally, when your report is finished, mark it as such:

```objective-c
[report finish];
```

Since services and reports are retrieved based on names, filling information, performing time measurements or marking a report as finished can be made from any application subsystem in a decentralized way, from any thread.

### Report submission

Once a report has been marked as finished, the associated service will automatically attempt to submit it after a while. Submission is made by serializing the report as JSON and calling a submission block on the service, which you can use to specify how the data is submitted. 

For example, you can POST the data to a webservice expecting it as body:

```objective-c
[SRGDiagnosticsService serviceWithName:@"playback_metrics"].submissionBlock = ^(NSDictionary * _Nonnull JSONDictionary, void (^ _Nonnull completionBlock)(BOOL)) {
    NSURL *URL = ...;
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    request.HTTPMethod = @"POST";
    request.HTTPBody = [NSJSONSerialization dataWithJSONObject:JSONDictionary options:0 error:NULL];
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        completionBlock(error != nil);
    }] resume];
};
```

or simply log the report to the console:

```objective-c
[SRGDiagnosticsService serviceWithName:@"playback_metrics"].submissionBlock = ^(NSDictionary * _Nonnull JSONDictionary, void (^ _Nonnull completionBlock)(BOOL)) {
    NSLog(@"Report: %@", JSONDictionary);
    completionBlock(YES);
};
```

The submission block can be updated at any time, though it should in general be setup once early in the application lifecycle. Once submission has been made, the supplied `completionBlock` must be called, with `YES` iff the submission was successful. Successfully submitted reports are discarded, otherwise the service will attempt to submit it later. The `submissionInterval` property lets you customize at which interval submissions are made.

## License

See the [LICENSE](../LICENSE) file for more information.
