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

// Macro version. When DEBUG is not set, method is ignored
// It also runs [MGBenchmarkSession total] for log output prior to finishing
#ifdef DEBUG
	#define MGBenchStart(__SESSION__) [MGBenchmark start:__SESSION__]
	#define MGBenchEnd(__SESSION__) [[MGBenchmark session:__SESSION__] total];[MGBenchmark finish:__SESSION__]
#else
	#define MGBenchStart(__SESSION__) do {} while (0)
	#define MGBenchEnd(__SESSION__) do {} while (0)
#endif

@protocol MGBenchmarkTarget;
@class MGBenchmarkSession;

@interface MGBenchmark : NSObject

/**
 * Set a default target. If nothing is provided it will log to the
 * console by default.
 */
+ (void)setDefaultTarget:(id <MGBenchmarkTarget>)target;

/**
 * Starts a new session and assigns the `defaultTarget`. An instance
 * of the session is returned.
 */
+ (MGBenchmarkSession *)start:(NSString *)sessionName;

/**
 * Returns session by name. You need to start it first!
 */
+ (MGBenchmarkSession *)session:(NSString *)sessionName;

/**
 * Finishes a session by name. This allows for garbage collection
 * in case the session is otherwise not referenced anymore.
 */
+ (void)finish:(NSString *)sessionName;

@end
