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

#import "MGConsoleOutput.h"
#import "MGBenchmarkSession.h"

@implementation MGConsoleOutput

- (void)sessionStarted:(MGBenchmarkSession *)session
{
	_session = session;
}

- (void)printPassedTime:(NSTimeInterval)passedTime forStep:(NSString *)step
{
	NSLog(@"<< BENCHMARK [%@/%@] %.2fs (step %d) >>",
			_session.name, step, passedTime, _session.stepCount);
}

- (void)printTotalTime:(NSTimeInterval)passedTime
{
	NSLog(@"<< BENCHMARK [%@/total] %.2fs ((%d steps, average %.2fs)) >>",
			_session.name, passedTime, _session.stepCount, _session.averageTime);
}

@end