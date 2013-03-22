#import "MGConsoleOutput.h"

@implementation MGConsoleOutput

- (void)printPassedTime:(NSTimeInterval)passedTime forStep:(NSString *)step
{
	NSLog(@"[%.2fs] for step '%@'", passedTime, step);
}

- (void)printTotalTime:(NSTimeInterval)passedTime
{
	NSLog(@"[%.2fs] in total", passedTime);
}

@end