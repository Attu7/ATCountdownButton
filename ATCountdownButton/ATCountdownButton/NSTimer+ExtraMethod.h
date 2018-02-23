//
//  NSTimer+ExtraMethod.h
//  ProgressViewDemo
//
//  Created by Attu on 2018/1/31.
//  Copyright © 2018年 Attu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (ExtraMethod)

+ (NSTimer *)at_scheduledTimerWithTimeInterval:(NSTimeInterval)seconds repeats:(BOOL)repeats block:(void (^)(NSTimer *timer))block;

- (void)pauseTimer;
- (void)resumeTimer;
- (void)stopTimer;
- (void)resumeTimerAfterTimeInterval:(NSTimeInterval)interval;

@end
