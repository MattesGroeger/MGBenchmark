## Introduction

This library provides an easy way to measure execution time within code. This is especially interesting for load operations that are difficult to profile with Instruments.

Features:
* Measure execution time of code
* Measure individual steps of executions
* Implement custom output targets
* Get the average execution time of all steps (tbd)
* Have multiple benchmark sessions at the same time (tbd)
* Will run by default only in DEBUG mode (tbd)

## Installation via CocoaPods (tbd)

- Install CocoaPods. See [http://cocoapods.org](http://cocoapods.org)
- Add the MGBenchmark reference to the Podfile:
```
    platform :ios
    	pod 'MGBenchmark'
    end
```

- Run `pod install` from the command line
- Open the newly created Xcode Workspace file
- Implement your commands

## Usage (Proposal)

Basic configuration and usage example:

```obj-c
// set the default output for all sessions
[MGBenchmark defaultOutput:[[MGConsoleOutput alloc] init]]];

// start a new benchmark session
MGBenchmarkSession *benchmark = [MGBenchmark start:@"foo"];

// code to measure
sleep(1);

// measure the first step
[benchmark step:@"1"];

// execute more code
sleep(1);

// you can always get started sessions via static access
[benchmark step:@"2"];

// measure the total/average session execution time
[benchmark total];

// cleanup session
[MGBenchmark finish:@"foo"];
```

Static access across different classes:

```obj-c
// Class A
[MGBenchmark start:@"bar"];

// Class B
[[MGBenchmark session:@"bar"] step:@"1"];

// Class C
[[MGBenchmark session:@"bar"] step:@"2"];

// Class D
[[MGBenchmark retrieve:@"bar"] total];
[MGBenchmark finish:@"bar"];
```