#import "MGBenchmarkSession.h"

@implementation MGBenchmarkSession

- (id)init
{
	self = [super init];

	if (self)
	{
		_lastInterim = _startTime = [NSDate date];
	}

	return self;
}

- (NSTimeInterval)interim
{
	NSTimeInterval timePassed = [self timePassedSince:_lastInterim];
	_lastInterim = [NSDate date];

	return timePassed;
}

- (NSTimeInterval)total
{
	return [self timePassedSince:_startTime];
}

- (NSTimeInterval)timePassedSince:(NSDate *)date
{
	return [[NSDate date] timeIntervalSinceDate:date];
}

@end
