/*
 * Copyright (c) 2013 Mattes Groeger
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

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

		it(@"should measure steps and total execution time", ^
		{
			[[output shouldEventuallyBeforeTimingOutAfter(2)] receive:@selector(printTotalTime:) withCount:2];
			[[output shouldEventuallyBeforeTimingOutAfter(2)] receive:@selector(printPassedTime:forStep:) withCount:2];

			sleep(1);

			[[theValue([benchmark step:@"foo"]) should] beGreaterThanOrEqualTo:theValue(1)];
			[[theValue([benchmark total]) should] beGreaterThanOrEqualTo:theValue(1)];

			sleep(1);

			[[theValue([benchmark step:nil]) should] beGreaterThanOrEqualTo:theValue(1)];
			[[theValue([benchmark total]) should] beGreaterThanOrEqualTo:theValue(2)];
		});
	});
});

SPEC_END