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

#import <Foundation/Foundation.h>

// Macro version. When DEBUG is not set, methods are ignored
#define MGBenchStep_1(__SESSION__) [[MGBenchmark session:__SESSION__] step:[NSString stringWithFormat:@"%@ %@", [self class], NSStringFromSelector(_cmd)]]
#define MGBenchStep_2(__SESSION__, __STEP__) [[MGBenchmark session:__SESSION__] step:__STEP__]
#define MGBenchStep_X(x,A,B,FUNC, ...) FUNC

#ifdef DEBUG
	#define MGBenchStep(...) MGBenchStep_X(,##__VA_ARGS__,\
		MGBenchStep_2(__VA_ARGS__),\
		MGBenchStep_1(__VA_ARGS__)\
	)
	#define MGBenchTotal(__SESSION__) [[MGBenchmark session:__SESSION__] total]
#else
	#define MGBenchStep(...) do {} while (0)
	#define MGBenchTotal(__SESSION__) do {} while (0)
#endif

@protocol MGBenchmarkTarget;

@interface MGBenchmarkSession : NSObject
{
	NSDate *_startTime;
	NSDate *_lastInterim;
}

@property (nonatomic) NSString *name;
@property (nonatomic) id <MGBenchmarkTarget> target;
@property (nonatomic, readonly) NSUInteger stepCount;
@property (nonatomic, readonly) NSTimeInterval averageTime;

- (id)initWithName:(NSString *)name andTarget:(id <MGBenchmarkTarget>)target;

- (NSTimeInterval)step:(NSString *)null;

- (NSTimeInterval)total;

@end
