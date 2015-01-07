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

#import "Kiwi.h"
#import "MGBenchmark.h"
#import "MGBenchmarkSession.h"
#import "MGConsoleOutput.h"

SPEC_BEGIN(MGBenchmarkSpec)

describe(@"MGBenchmark", ^
{
	it(@"should return nil session if not started", ^
	{
		[[MGBenchmark session:@"foo"] shouldBeNil];
	});

	it(@"should start and finish session", ^
	{
		MGBenchmarkSession *result = [MGBenchmark start:@"foo"];

		[result shouldNotBeNil];
		[[(NSObject *)result.target should] beKindOfClass:[MGConsoleOutput class]];
		[[result should] equal:[MGBenchmark session:@"foo"]];

		[MGBenchmark finish:@"foo"];

		[[MGBenchmark session:@"foo"] shouldBeNil];
	});

	it(@"should override existing session when started twice", ^
	{
		[MGBenchmark start:@"foo"];
		[MGBenchmark start:@"foo"];

		[MGBenchmark finish:@"foo"];

		[[MGBenchmark session:@"foo"] shouldBeNil];
	});

	it(@"should silently ignore when finishing a never started session", ^
	{
		[MGBenchmark finish:@"foo"];
	});

	it(@"should assign default target", ^
	{
		id <MGBenchmarkTarget> target = (id <MGBenchmarkTarget>) [KWMock nullMockForProtocol:@protocol(MGBenchmarkTarget)];
		[MGBenchmark setDefaultTarget:target];

		MGBenchmarkSession *result = [MGBenchmark start:@"foo"];

		[[(NSObject *)result.target should] equal:target];

		[MGBenchmark finish:@"foo"];
	});

    it(@"should assign to alternate target", ^
       {
           id <MGBenchmarkTarget> defaultTarget = (id <MGBenchmarkTarget>) [KWMock nullMockForProtocol:@protocol(MGBenchmarkTarget)];

           [MGBenchmark setDefaultTarget:defaultTarget];

           id <MGBenchmarkTarget> alternateTarget = (id <MGBenchmarkTarget>) [KWMock nullMockForProtocol:@protocol(MGBenchmarkTarget)];

           MGBenchmarkSession *result = [MGBenchmark start:@"foo" target:alternateTarget];

           [[(NSObject *)result.target should] equal:alternateTarget];

           [MGBenchmark finish:@"foo"];
       });

	it(@"should be able to access session from different thread", ^
	{
		__block MGBenchmarkSession *session = [MGBenchmark start:@"foo"];

		dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^
		{
			[[[MGBenchmark session:@"foo"] should] equal:session];
		});
	});
});

SPEC_END