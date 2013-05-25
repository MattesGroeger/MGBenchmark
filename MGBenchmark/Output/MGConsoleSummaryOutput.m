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

#import "MGConsoleSummaryOutput.h"
#import "MGBenchmarkSession.h"
#import "MGConsoleUtil.h"


@implementation MGBenchmarkStepData

@end

@implementation MGConsoleSummaryOutput

- (id)init
{
	self = [super init];
    
	if (self)
	{
		_stepData = [NSMutableArray array];
		_totalStepTime = 0;
		_logStepsInstantly = NO;
		_summaryFormat = @"<< BENCHMARK ${stepTime} (${stepPercent}%) ${stepName} >>";
	}
    
	return self;
}

- (void)passedTime:(NSTimeInterval)passedTime forStep:(NSString *)stepName inSession:(MGBenchmarkSession *)session
{
	if (_logStepsInstantly)
		[super passedTime:passedTime forStep:stepName inSession:session];
    
	MGBenchmarkStepData *data = [[MGBenchmarkStepData alloc] init];
	data.stepCount = session.stepCount;
	data.stepTime = passedTime;
	data.stepName = stepName;
    
	[_stepData addObject:data];
    
	_totalStepTime += passedTime;
}

- (void)totalTime:(NSTimeInterval)passedTime inSession:(MGBenchmarkSession *)session
{
	[super totalTime:passedTime inSession:session];
    
	NSArray *sortedSteps = [_stepData sortedArrayUsingComparator:^NSComparisonResult(id a, id b)
                            {
                                NSTimeInterval first = [(MGBenchmarkStepData *) a stepTime];
                                NSTimeInterval second = [(MGBenchmarkStepData *) b stepTime];
                                return [@(second) compare:@(first)];
                            }];
    
	for (MGBenchmarkStepData *data in sortedSteps)
	{
		[MGConsoleUtil logWithFormat:_summaryFormat andReplacement:@{
         @"sessionName": session.name,
         @"stepTime": [MGConsoleUtil formatTime:data.stepTime format:self.timeFormat multiplier:self.timeMultiplier],
         @"stepPercent": [NSString stringWithFormat:@"%.1f", data.stepTime / _totalStepTime * 100],
         @"stepName": data.stepName,
         @"stepNumber": @(data.stepCount)
         }];
	}
}

@end