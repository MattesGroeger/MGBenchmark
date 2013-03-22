#import "MGBenchmarkSession.h"
#import "MGBenchmarkOutput.h"

@implementation MGBenchmarkSession

- (id)initWithOutput:(id <MGBenchmarkOutput>)output
{
	self = [super init];

	if (self)
	{
		_lastInterim = _startTime = [NSDate date];
		_output = output;
	}

	return self;
}

- (NSTimeInterval)interim:(NSString *)step
{
	NSTimeInterval timePassed = [self timePassedSince:_lastInterim];
	_lastInterim = [NSDate date];

	[_output printPassedTime:timePassed forStep:step];

	return timePassed;
}

- (NSTimeInterval)total
{
	NSTimeInterval timePassed = [self timePassedSince:_startTime];

	[_output printTotalTime:timePassed];
	
	return timePassed;
}

- (NSTimeInterval)timePassedSince:(NSDate *)date
{
	return [[NSDate date] timeIntervalSinceDate:date];
}

@end
