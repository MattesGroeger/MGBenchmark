[![Build Status](https://travis-ci.org/MattesGroeger/MGBenchmark.png?branch=master)](https://travis-ci.org/MattesGroeger/MGBenchmark) [![Coverage Status](https://coveralls.io/repos/MattesGroeger/MGBenchmark/badge.png)](https://coveralls.io/r/MattesGroeger/MGBenchmark)

## Introduction

Easily measure code execution times. This is especially interesting for load operations that are difficult to profile with [Instruments](http://developer.apple.com/library/mac/#documentation/DeveloperTools/Conceptual/InstrumentsUserGuide/Introduction/Introduction.html).

### Features

* Measure total execution times
* Measure individual steps of execution
* Find steps that take longest
* Get the average execution time of all steps
* Have multiple benchmark sessions at the same time
* Use macros for easy usage
* Implement custom output targets
* Measure times across different threads (thread-safe)

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

The quickest way is to use the provided macros. They give you the basic console log functionality with very little code. The benchmark will only work when `DEBUG` is set.

```obj-c
#import "MGBenchmark.h"

MGBenchStart(@"Test");

// code to measure

MGBenchStep(@"Test", @"1"); // << BENCHMARK [Test/1] 0.01s (step 1) >>

// code to measure

MGBenchStep(@"Test", @"2"); // << BENCHMARK [Test/2] 0.01s (step 2) >>
MGBenchEnd(@"Test"); // << BENCHMARK [Test/total] 0.02s (2 steps, average 0.01s) >>
```

That's it. For most cases that should be enough. However if you want to customize the output that's possible as well.

## Class methods

The aforementioned macros use the following class methods under the hood:

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

## Live Environment

You can keep the benchmark code integrated even in the live environment. But rather then logging to the console, you should send the results [to a tracking database](#custom-output-target). Or set the target to `nil` to ignore the results.

```objc
#if DEBUG
[MGBenchmark setDefaultTarget:[[MGConsoleOutput alloc] init]]; // log to console
#elif RELEASE
[MGBenchmark setDefaultTarget:[[FlurryTarget alloc] init]]; // send to server
#else
[MGBenchmark setDefaultTarget:nil]; // ignore results
#endif
```

## Customizing the Logs

There are different ways to customize the benchmark results:
* Directly use the results
* Customize the default target
* Choose another pre-defined target
* Implement your own output target

### Using Results Directly

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

### Customize the Default Target MGConsoleOutput

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

### MGConsoleSummaryOutput

Use this target to find steps that take longest. When using the `total` method it will print out all individual steps ordered by time.

Using...

```obj-c
[MGBenchmark setDefaultTarget:[[MGConsoleSummaryOutput alloc] init]];
```

... will result in these logs:

```
<< BENCHMARK [demo/total] 4.00138s (3 steps, average 1.33379s) >>
<< BENCHMARK 2.00084s (50.0%) step2 >>                           
<< BENCHMARK 1.00039s (25.0%) step1 >>                           
<< BENCHMARK 1.00010s (25.0%) step3 >>
```

You can customize this target as well ([see the example code](https://github.com/MattesGroeger/MGBenchmark/blob/master/MGBenchmarkExample/ViewController.m)).

### Custom Output Target

If you want to use a different output format, the best way is to define a custom target. For that you need to implement the `MGBenchmarkTarget` protocol. It declares 3 methods which are all optional:

* `passedTime:forStep:inSession` – called for step time benchmark
* `totalTime:inSession` – called for total time benchmark

Here is an example that sends the total benchmark to [Flurry](http://www.flurry.com/flurry-analytics.html). Note that you need to initialize Flurry beforehand.

```obj-c
@interface FlurryTarget : NSObject <MGBenchmarkTarget>
@end
```

```obj-c
@implementation FlurryTarget

- (void)totalTime:(NSTimeInterval)passedTime inSession:(MGBenchmarkSession*)session
{
	[Flurry logEvent:session.name withParameters:@{
		@"totalTime": [NSString stringWithFormat:@"%.5fs", passedTime],
		@"steps": @(session.stepCount),
		@"averageStepTime": [NSString stringWithFormat:@"%.5fs", session.averageTime]
	}];
}

@end
```

Use your custom output target:

```obj-c
// set the default output for all sessions
[MGBenchmark setDefaultTarget:[[FlurryTarget alloc] init]]];
```

## Changelog

**0.3.0** (2014/01/17)

* [NEW] Macros for easier usage (Thanks [Nano](https://github.com/workwithnano))
* [CHANGED] Simplified output target session handling (no need to store session)

**0.2.0** (2013/03/28)

* [NEW] `MGBenchmark` is now thread-safe
* [NEW] `MGBenchmarkTarget` protocol methods are optional now
* [NEW] `MGConsoleSummaryOutput` for sorted step times (what takes longest?)

**0.1.1** (2013/03/24)

* [BUGFIX] More fault-tolerant (doesn't use NSAssert anymore)

**0.1.0** (2013/03/24)

* [NEW] Measure total execution times
* [NEW] Measure individual steps of execution
* [NEW] Get the average execution time of all steps
* [NEW] Have multiple benchmark sessions at the same time
* [NEW] Implement custom output targets

## Contribution

This library is released under the [MIT licence](http://opensource.org/licenses/MIT). Contributions are more than welcome!

Also, follow me on Twitter if you like: [@MattesGroeger](https://twitter.com/MattesGroeger).
