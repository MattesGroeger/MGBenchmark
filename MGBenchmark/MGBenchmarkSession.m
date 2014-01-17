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

#import "MGBenchmarkSession.h"
#import "MGBenchmarkTarget.h"

@implementation MGBenchmarkSession

- (id)init
{
	return [self initWithName:nil andTarget:nil];
}

- (id)initWithName:(NSString *)name andTarget:(id <MGBenchmarkTarget>)target
{
	self = [super init];
    
	if (self)
	{
		_lastInterim = _startTime = [NSDate date];
		_name = name;
		_target = target;
	}
    
	return self;
}

- (NSTimeInterval)averageTime
{
	if (_stepCount == 0)
		return 0;
    
	return [_lastInterim timeIntervalSinceDate:_startTime] / _stepCount;
}

- (NSTimeInterval)step:(NSString *)step
{
	NSTimeInterval timePassed = [self timePassedSince:_lastInterim];
	_lastInterim = [NSDate date];
	_stepCount++;
    
	if (_target && [_target respondsToSelector:@selector(passedTime:forStep:inSession:)])
		[_target passedTime:timePassed forStep:step inSession:self];
    
	return timePassed;
}

- (NSTimeInterval)total
{
	NSTimeInterval timePassed = [self timePassedSince:_startTime];
    
	if (_target && [_target respondsToSelector:@selector(totalTime:inSession:)])
		[_target totalTime:timePassed inSession:self];
	
	return timePassed;
}

- (NSTimeInterval)timePassedSince:(NSDate *)date
{
	return [[NSDate date] timeIntervalSinceDate:date];
}

@end
