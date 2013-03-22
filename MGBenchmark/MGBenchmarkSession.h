#import <Foundation/Foundation.h>

@interface MGBenchmarkSession : NSObject
{
	NSDate *_startTime;
	NSDate *_lastInterim;
}

- (NSTimeInterval)interim;

- (NSTimeInterval)total;

@end
