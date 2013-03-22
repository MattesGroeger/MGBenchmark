#import <Foundation/Foundation.h>

@protocol MGBenchmarkOutput <NSObject>

- (void)printPassedTime:(NSTimeInterval)passedTime forStep:(NSString *)step;

- (void)printTotalTime:(NSTimeInterval)passedTime;

@end