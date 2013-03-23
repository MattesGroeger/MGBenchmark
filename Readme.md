## Introduction

This library provides an easy way to measure execution time within code. This is especially interesting for load operations that are difficult to profile with Instruments.

Features:
* Measure execution time of code
* Measure individual steps of executions
* Implement custom output targets
* Get the average execution time of all steps (tbd)
* Have multiple benchmark sessions at the same time (tbd)
* Support pause/resume (tbd)
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
// start a new benchmark session
MGBenchmarkSession *benchmark = [[MGBenchmarkSession alloc] initWithName:@"foo" andTarget:[[MGConsoleOutput alloc] init]];

// code to measure
sleep(1);

// measure the first step
[benchmark step:@"sleep1"]; // << BENCHMARK [foo/sleep1] 1.01s (step 1) >>

// execute more code
sleep(2);

// you can always get started sessions via static access
[benchmark step:@"sleep2"]; // << BENCHMARK [foo/sleep2] 2.01s (step 2) >>

// summarize the total/average session execution time
[benchmark total]; // << BENCHMARK [foo/total] 3.03s (2 steps, average 2.02s) >>

sleep(1);

// you can go on...
[benchmark step:@"sleep3"]; // << BENCHMARK [foo/sleep3] 1.01s (step 3) >>
[benchmark total]; // << BENCHMARK [foo/total] 4.04s (3 steps, average 2.69s) >>
```

Static access across different classes:

```obj-c
// set the default output for all sessions
[MGBenchmark defaultOutput:[[MGConsoleOutput alloc] init]]];

// Class A
[MGBenchmark start:@"bar"];

// Class B
[[MGBenchmark session:@"bar"] step:@"1"];

// Class C
[[MGBenchmark session:@"bar"] step:@"2"];
[[MGBenchmark session:@"bar"] total];

// cleanup session
[MGBenchmark finish:@"bar"];
```