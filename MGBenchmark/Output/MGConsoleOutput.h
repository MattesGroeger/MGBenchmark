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
#import <CoreGraphics/CoreGraphics.h>
#import "MGBenchmarkTarget.h"

@class MGBenchmarkSession;

@interface MGConsoleOutput : NSObject <MGBenchmarkTarget>
{
}

/**
 * You can define a custom output string for each step by using the following
 * placeholders:
 *
 * ${sessionName}
 * ${stepName}
 * ${passedTime}
 * ${stepCount}
 *
 * Example:
 * consoleOutput.stepFormat = @"<< BENCHMARK [${sessionName}/${stepName}] ${passedTime} (step ${stepCount}) >>";
 */
@property (strong) NSString *stepFormat;

/**
 * You can define a custom output string for the total time by using the
 * following placeholders:
 *
 * ${sessionName}
 * ${passedTime}
 * ${stepCount}
 * ${averageTime}
 *
 * Example:
 * consoleOutput.totalFormat = @"<< BENCHMARK [${sessionName}/total] ${passedTime} (${stepCount} steps, average ${averageTime}) >>";
 */
@property (nonatomic, strong) NSString *totalFormat;

/**
 * You can define a custom time format using the `stringWithFormat` notation
 * for float values. By default it will use @"%.5fs", resulting in "1.34245s"
 * for example.
 */
@property (nonatomic, strong) NSString *timeFormat;

/**
 * In case you want to output the time in MS or Minutes rather then seconds,
 * use the multiplier (e.g. 1000 for MS).
 */
@property (nonatomic) CGFloat timeMultiplier;

@end