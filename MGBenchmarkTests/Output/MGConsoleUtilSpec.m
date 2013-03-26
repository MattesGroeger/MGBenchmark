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
#import "MGConsoleUtil.h"

SPEC_BEGIN(MGConsoleUtilSpec)

describe(@"MGConsoleUtil", ^
{
	it(@"should create proper time format", ^
	{
		NSTimeInterval timeInterval = [[NSDate dateWithTimeIntervalSince1970:16.34674533245] timeIntervalSince1970];

		[[[MGConsoleUtil formatTime:timeInterval format:@"%.2fs" multiplier:1] should] equal:@"16.35s"];
		[[[MGConsoleUtil formatTime:timeInterval format:@"%.1fs" multiplier:1000] should] equal:@"16346.7s"];
		[[[MGConsoleUtil formatTime:timeInterval format:@"%.0fs" multiplier:1] should] equal:@"16s"];
	});

	it(@"should create proper log string", ^
	{
		[[[MGConsoleUtil string:@"foo" withKeyValueReplacement:@{}] should] equal:@"foo"];
		[[[MGConsoleUtil string:@"foo" withKeyValueReplacement:@{@"bar":@"val1"}] should] equal:@"foo"];
		[[[MGConsoleUtil string:@"${bar}" withKeyValueReplacement:@{@"bar":@"val1"}] should] equal:@"val1"];
		[[[MGConsoleUtil string:@"long${bar}word" withKeyValueReplacement:@{@"bar":@"val1"}] should] equal:@"longval1word"];
		[[[MGConsoleUtil string:@"foo ${unknown}" withKeyValueReplacement:@{@"bar":@"val1"}] should] equal:@"foo ${unknown}"];
		[[[MGConsoleUtil string:@"foo ${bar} ${unknown}" withKeyValueReplacement:@{@"bar":@"val1", @"test":@"val2"}] should] equal:@"foo val1 ${unknown}"];
	});
});

SPEC_END