## Introduction

This library provides an easy way to measure execution time within code. This is especially interesting for load operations that are difficult to profile with Instruments.

### Features

* Measure total execution times
* Measure individual steps of execution
* Get the average execution time of all steps
* Have multiple benchmark sessions at the same time
* Implement custom output targets
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

## Quick Usage

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

## Customizing the logs

### Custom console output

You can easily create your own console logs. For that you have to disable the default console output:

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

### Custom output target

If you want to use a different output format, the best way is to define a custom target. For that you need to implement the `MGBenchmarkTarget` protocol:

```obj-c
@interface CustomOutput : NSObject <MGBenchmarkTarget>
{
    MGBenchmarkSession *_session;
}

@end
```

```obj-c
@implementation CustomOutput

- (void)sessionStarted:(MGBenchmarkSession *)session
{
    _session = session;
}

- (void)printPassedTime:(NSTimeInterval)passedTime forStep:(NSString *)step
{
	NSLog(@"[%@/%@] %.5fs (step %d)", _session.name, step, passedTime, _session.stepCount);
}

- (void)printTotalTime:(NSTimeInterval)passedTime
{
	NSLog(@"[%@/total] %.5fs ((%d steps, average %.5fs))", _session.name, passedTime, _session.stepCount, _session.averageTime);
}

@end
```

Of course, you are not limited to console output here. You could also send the data to a server.

Use your custom output target:

```obj-c
// set the default output for all sessions
[MGBenchmark setDefaultTarget:[[CustomOutput alloc] init]]];
```
