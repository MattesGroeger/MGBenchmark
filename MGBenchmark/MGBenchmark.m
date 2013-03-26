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

#import "MGBenchmark.h"
#import "MGBenchmarkTarget.h"
#import "MGBenchmarkSession.h"
#import "MGConsoleOutput.h"


NSMutableDictionary *_sessions;
id <MGBenchmarkTarget> _defaultTarget;
dispatch_queue_t _benchmarkQueue;

@implementation MGBenchmark

+ (void)initialize
{
	_sessions = [NSMutableDictionary dictionary];
	_defaultTarget = [[MGConsoleOutput alloc] init];
	_benchmarkQueue = dispatch_queue_create("de.mattesgroeger.benchmark", NULL);
}

+ (void)setDefaultTarget:(id <MGBenchmarkTarget>)target
{
	dispatch_sync(_benchmarkQueue, ^
	{
		_defaultTarget = target;
	});
}

+ (MGBenchmarkSession *)start:(NSString *)sessionName
{
	__block MGBenchmarkSession *session = [[MGBenchmarkSession alloc] initWithName:sessionName andTarget:_defaultTarget];

	dispatch_sync(_benchmarkQueue, ^
	{
		_sessions[sessionName] = session;
	});

	return session;
}

+ (MGBenchmarkSession *)session:(NSString *)sessionName
{
	__block MGBenchmarkSession *session = nil;

	dispatch_sync(_benchmarkQueue, ^
	{
		session = _sessions[sessionName];
	});

	return session;
}

+ (void)finish:(NSString *)sessionName
{
	dispatch_sync(_benchmarkQueue, ^
	{
		[_sessions removeObjectForKey:sessionName];
	});
}

@end