#import <Foundation/Foundation.h>

@protocol MGBenchmarkOutput;

@interface MGBenchmarkSession : NSObject
{
	NSDate *_startTime;
	NSDate *_lastInterim;
	id <MGBenchmarkOutput> _output;
}

- (id)initWithOutput:(id <MGBenchmarkOutput>)output;

- (NSTimeInterval)interim:(NSString *)null;

- (NSTimeInterval)total;

@end
