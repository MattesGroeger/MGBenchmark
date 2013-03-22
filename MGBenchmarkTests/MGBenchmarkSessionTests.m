#import "MGBenchmarkSession.h"
#import "Kiwi.h"

SPEC_BEGIN(MGBenchmarkSpec)

describe(@"MGBenchmarkSession", ^
{
	__block MGBenchmarkSession *benchmark;

	beforeEach(^
	{
		benchmark = [[MGBenchmarkSession alloc] init];
	});

	context(@"with fresh setup", ^
	{
		it(@"should measure total execution time", ^
		{
			sleep(1);

			[[theValue([benchmark total]) should] beGreaterThanOrEqualTo:theValue(1)];
		});

		it(@"should measure interims and total execution time", ^
		{
			sleep(1);

			[[theValue([benchmark interim]) should] beGreaterThanOrEqualTo:theValue(1)];
			[[theValue([benchmark total]) should] beGreaterThanOrEqualTo:theValue(1)];

			sleep(1);

			[[theValue([benchmark interim]) should] beGreaterThanOrEqualTo:theValue(1)];
			[[theValue([benchmark total]) should] beGreaterThanOrEqualTo:theValue(2)];
		});
	});
});

SPEC_END