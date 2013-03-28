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


static NSMutableDictionary *sessions;
static id <MGBenchmarkTarget> defaultTarget;
static dispatch_queue_t benchmarkQueue;

@implementation MGBenchmark

+ (void)initialize
{
	sessions = [NSMutableDictionary dictionary];
	defaultTarget = [[MGConsoleOutput alloc] init];
	benchmarkQueue = dispatch_queue_create("de.mattesgroeger.benchmark", DISPATCH_QUEUE_SERIAL);
}

+ (void)setDefaultTarget:(id <MGBenchmarkTarget>)target
{
	dispatch_sync(benchmarkQueue, ^
	{
		defaultTarget = target;
	});
}

+ (MGBenchmarkSession *)start:(NSString *)sessionName
{
	__block MGBenchmarkSession *session = [[MGBenchmarkSession alloc] initWithName:sessionName andTarget:defaultTarget];

	dispatch_sync(benchmarkQueue, ^
	{
		sessions[sessionName] = session;
	});

	return session;
}

+ (MGBenchmarkSession *)session:(NSString *)sessionName
{
	__block MGBenchmarkSession *session = nil;

	dispatch_sync(benchmarkQueue, ^
	{
		session = sessions[sessionName];
	});

	return session;
}

+ (void)finish:(NSString *)sessionName
{
	dispatch_sync(benchmarkQueue, ^
	{
		[sessions removeObjectForKey:sessionName];
	});
}

@end