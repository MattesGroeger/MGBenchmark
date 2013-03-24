## Introduction

Easily measure execution times within code. This is especially interesting for load operations that are difficult to profile with [Instruments](http://developer.apple.com/library/mac/#documentation/DeveloperTools/Conceptual/InstrumentsUserGuide/Introduction/Introduction.html).

### Features

* Measure total execution times
* Measure individual steps of execution
* Get the average execution time of all steps
* Have multiple benchmark sessions at the same time
* Implement custom output targets

## Installation via CocoaPods

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

## Quick Guide

Using the class methods of `MGBenchmark` allows to benchmark times accross classes. No need to pass references around. The results will be shown in the console.

```obj-c
[MGBenchmark start:@"demo"]; // start measuring

// code to measure

[[MGBenchmark session:@"demo"] step:@"1"]; // << BENCHMARK [demo/1] 0.01s (step 1) >>

// code to measure

[[MGBenchmark session:@"demo"] step:@"2"]; // << BENCHMARK [demo/2] 0.01s (step 2) >>
[[MGBenchmark session:@"demo"] total]; // << BENCHMARK [demo/total] 0.02s (2 steps, average 0.01s) >>

[MGBenchmark finish:@"demo"]; // garbage collect
```

Nevertheless `[MGBenchmark start:@"foo"]` returns an instance as well:

```obj-c
MGBenchmarkSession *session = [MGBenchmark start:@"demo"];

[session step:@"1"];
[session step:@"2"];
[session total];

[MGBenchmark finish:@"demo"]; // garbage collect
```

## Customizing the logs

There are 3 different ways to customize the benchmark results:
* Directly use the results
* Customize the console output
* Implement your own output target

### Using results directly

You can easily create your own console logs. For that you should disable the default console output:

```obj-c
[MGBenchmark setDefaultTarget:nil];
```

Then you can use the return values of `step:` and `total` to do your custom logging:

```obj-c
MGBenchmarkSession *benchmark = [MGBenchmark start:@"custom"];

// code to measure

NSLog(@"%.2fs", [benchmark step:@"sleep1"]); // 1.01s

// code to measure

NSLog(@"%.2fs", [benchmark step:@"sleep2"]); // 2.01s
```

You can also access the amount of steps as well as the average execution times:

```obj-c
NSLog(@"%.2fs (steps: %d | average: %d)", [benchmark total], benchmark.stepCount, benchmark.averageTime); // 3.03s (steps: 2 | average: 2.02s)
```

### Customize the MGConsoleOutput

The provided console target is very customizable. You can configure the output by providing strings containing placeholders. The available placeholders differ for the `step:` and `total` benchmark:

**Step**
```
${sessionName}
${stepName}
${passedTime}
${stepCount}
```

**Total**
```
${sessionName}
${passedTime}
${stepCount}
${averageTime}
```

You can also change the measured time format. By changing the multiplier you can get measured times in milliseconds for example:

```obj-c
MGConsoleOutput *output = [[MGConsoleOutput alloc] init];
output.timeMultiplier = 1000; // to get ms rather than seconds
output.timeFormat = @"%.3fms"; // with 3 digits after comma
output.stepFormat = @"${stepName}: ${passedTime}";
output.totalFormat = @"total: ${passedTime}";

[MGBenchmark setDefaultTarget:output];

id session = [MGBenchmark start:@"demo"];
[session step:@"step1"]; 	// step1: 0.004ms
[session step:@"step2"]; 	// step2: 0.320ms
[session step:@"step3"]; 	// step3: 0.298ms
[session total]; 			// total: 0.884ms
[MGBenchmark finish:@"demo"];
```

### Custom output target

If you want to use a different output format, the best way is to define a custom target. For that you need to implement the `MGBenchmarkTarget` protocol. Here is an example that sends the results to [Flurry](http://www.flurry.com/flurry-analytics.html). Note that you need to initialize Flurry beforehand.

```obj-c
@interface FlurryTarget : NSObject <MGBenchmarkTarget>
{
    MGBenchmarkSession *_session;
}

@end
```

```obj-c
@implementation FlurryTarget

- (void)sessionStarted:(MGBenchmarkSession *)session
{
	_session = session;
}

- (void)passedTime:(NSTimeInterval)passedTime forStep:(NSString *)step
{
	// ignore steps
}

- (void)totalTime:(NSTimeInterval)passedTime
{
	[Flurry logEvent:_session.name withParameters:@{
		@"totalTime": [NSString stringWithFormat:@"%.5fs", passedTime],
		@"steps": @(_session.stepCount),
		@"averageStepTime": [NSString stringWithFormat:@"%.5fs", _session.averageTime]
	}];
}

@end
```

Use your custom output target:

```obj-c
// set the default output for all sessions
[MGBenchmark setDefaultTarget:[[FlurryTarget alloc] init]]];
```
