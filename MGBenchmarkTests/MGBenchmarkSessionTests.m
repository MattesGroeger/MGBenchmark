#import <MGBenchmark/MGBenchmarkOutput.h>
#import "MGBenchmarkSession.h"
#import "Kiwi.h"

SPEC_BEGIN(MGBenchmarkSpec)

describe(@"MGBenchmarkSession", ^
{
	__block id output;
	__block MGBenchmarkSession *benchmark;

	beforeEach(^
	{
		output = [KWMock mockForProtocol:@protocol(MGBenchmarkOutput)];
		benchmark = [[MGBenchmarkSession alloc] initWithOutput:output];
	});

	context(@"with fresh setup", ^
	{
		it(@"should measure total execution time", ^
		{
			[[output shouldEventuallyBeforeTimingOutAfter(1)] receive:@selector(printTotalTime:)];

			sleep(1);

			[[theValue([benchmark total]) should] beGreaterThanOrEqualTo:theValue(1)];
		});

		it(@"should measure interims and total execution time", ^
		{
			[[output shouldEventuallyBeforeTimingOutAfter(2)] receive:@selector(printTotalTime:) withCount:2];
			[[output shouldEventuallyBeforeTimingOutAfter(2)] receive:@selector(printPassedTime:forStep:) withCount:2];

			sleep(1);

			[[theValue([benchmark interim:@"foo"]) should] beGreaterThanOrEqualTo:theValue(1)];
			[[theValue([benchmark total]) should] beGreaterThanOrEqualTo:theValue(1)];

			sleep(1);

			[[theValue([benchmark interim:nil]) should] beGreaterThanOrEqualTo:theValue(1)];
			[[theValue([benchmark total]) should] beGreaterThanOrEqualTo:theValue(2)];
		});
	});
});

SPEC_END