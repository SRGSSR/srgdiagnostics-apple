[![SRG Diagnostics logo](README-images/logo.png)](https://github.com/SRGSSR/srgdiagnostics-apple)

[![GitHub releases](https://img.shields.io/github/v/release/SRGSSR/srgdiagnostics-apple)](https://github.com/SRGSSR/srgdiagnostics-apple/releases) [![platform](https://img.shields.io/badge/platfom-ios%20%7C%20tvos%20%7C%20watchos-blue)](https://github.com/SRGSSR/srgdiagnostics-apple) [![SPM compatible](https://img.shields.io/badge/SPM-compatible-4BC51D.svg?style=flat)](https://swift.org/package-manager) [![GitHub license](https://img.shields.io/github/license/SRGSSR/srgdiagnostics-apple)](https://github.com/SRGSSR/srgdiagnostics-apple/blob/master/LICENSE)

## About

The SRG Diagnostics library is a set of lightweight components for collecting various application data for diagnostics purposes. The library is based on two main types of components:

* Reports, for collecting data.
* Services, responsible of report submission.

Reports and services are referenced by name and lazily created when accessed first. This makes it possible to create, fill and submit reports in a decentralized way. Note that diagnostics reports are not considered critical and are therefore not persisted between application sessions. You must never use such reports to convey data you cannot afford to lose.

## Compatibility

The library is suitable for applications running on iOS 9, tvOS 12, watchOS 5 and above. The project is meant to be compiled with the latest Xcode version.

## Contributing

If you want to contribute to the project, have a look at our [contributing guide](CONTRIBUTING.md).

## Integration

The library must be integrated using [Swift Package Manager](https://swift.org/package-manager) directly [within Xcode](https://developer.apple.com/documentation/xcode/adding_package_dependencies_to_your_app). You can also declare the library as a dependency of another one directly in the associated `Package.swift` manifest.

## Usage

When you want to use classes or functions provided by the library in your code, you must import it from your source files first. In Objective-C:

```objective-c
@import SRGDiagnostics;
```

or in Swift:

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
        completionBlock(error == nil);
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

### Report disposal

Reports stay alive until submitted. If for some reason a report will never be sent, you should discard it to free the associated resources:

```objective-c
[report discard];
```

## License

See the [LICENSE](../LICENSE) file for more information.
