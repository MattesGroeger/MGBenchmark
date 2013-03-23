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

	it(@"should fail to start same session twice", ^
	{
		[MGBenchmark start:@"foo"];

		[[theBlock(^
		{
			[MGBenchmark start:@"foo"];
		}) should] raiseWithReason:@"Can't start session. A session with name 'foo' was already started!"];

		[MGBenchmark finish:@"foo"];
	});

	it(@"should fail to finish never started session", ^
	{
		[[theBlock(^
		{
			[MGBenchmark finish:@"foo"];
		}) should] raiseWithReason:@"Can't finish session with name 'foo'. The session was never started!"];
	});

	it(@"should assign default target", ^
	{
		id <MGBenchmarkTarget> target = (id <MGBenchmarkTarget>) [KWMock nullMockForProtocol:@protocol(MGBenchmarkTarget)];
		[MGBenchmark setDefaultTarget:target];

		MGBenchmarkSession *result = [MGBenchmark start:@"foo"];

		[[(NSObject *)result.target should] equal:target];

		[MGBenchmark finish:@"foo"];
	});
});

SPEC_END