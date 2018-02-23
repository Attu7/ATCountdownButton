//
//  ATCountdownButton.m
//  KYPlatform
//
//  Created by Attu on 2017/8/30.
//  Copyright © 2017年 Attu. All rights reserved.
//

#import "ATCountdownButton.h"
#import "NSTimer+ExtraMethod.h"

typedef void(^ATCountdownCompletionBlock)(BOOL finished);

@interface ATCountdownButton ()
{
    CGPoint center;//中心点
}

@property (nonatomic, strong) CAShapeLayer *backGroundLayer; //背景图层
@property (nonatomic, strong) CAShapeLayer *frontFillLayer;//用来填充的图层
@property (nonatomic, strong) UIBezierPath *backGroundBezierPath;//背景贝赛尔曲线
@property (nonatomic, strong) UIBezierPath *frontFillBezierPath;//用来填充的贝赛尔曲线

@property (nonatomic, weak) NSTimer * timer;//定时器用作动画
@property (nonatomic, copy) ATCountdownCompletionBlock completionBlock;

@end

@implementation ATCountdownButton

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup]; 
    }
    return self;
}

- (void)setup {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(countdownButtonEnterBcakground:) name:UIApplicationWillResignActiveNotification object:nil]; //进入后台
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(countdownButtonEnterForeground:) name:UIApplicationDidBecomeActiveNotification object:nil]; // 返回前台
    
    //创建背景图层
    self.backGroundLayer = [CAShapeLayer layer];
    self.backGroundLayer.fillColor = nil;
    
    //创建填充图层
    self.frontFillLayer = [CAShapeLayer layer];
    self.frontFillLayer.fillColor = nil;
    self.frontFillLayer.lineJoin = kCALineJoinRound;
    
    self.progressColor = [UIColor redColor];
    self.progressTrackColor = [UIColor grayColor];
    self.progressWidth = 2.0f;
}

- (void)startWithDuration:(CGFloat)duration block:(void (^)(CGFloat))block completion:(void (^)(BOOL))completion {
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
        self.completionBlock = nil;
    }
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    self.frontFillLayer.strokeEnd = 0;
    [CATransaction commit];
    
    self.completionBlock = completion;
    CGFloat timeInterval = 0.1f;
    CGFloat percent = 1.0f/(duration/timeInterval);
    
    __weak typeof(self) weakSelf = self;
    self.timer = [NSTimer at_scheduledTimerWithTimeInterval:timeInterval repeats:YES block:^(NSTimer * _Nonnull timer) {
        if (weakSelf.frontFillLayer.strokeEnd >= 1) {
            [weakSelf stop];
        } else {
            weakSelf.frontFillLayer.strokeEnd += percent;
            if (block) {
                block(weakSelf.frontFillLayer.strokeEnd * duration);
            }
        }
    }];
}

- (void)pause {
    [self.timer pauseTimer];
}

- (void)resume {
    [self.timer resumeTimer];
}

- (void)stop {
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    self.frontFillLayer.strokeEnd = 0;
    [CATransaction commit];
    
    [self.timer stopTimer];
    self.timer = nil;
    
    if (self.completionBlock) {
        if (self.frontFillLayer.strokeEnd >= 1) {
            self.completionBlock(YES);
        } else {
            self.completionBlock(NO);
        }
    }
}

#pragma mark - Event

- (void)countdownButtonEnterBcakground:(NSNotification *)notice {
    [self pause];
}

- (void)countdownButtonEnterForeground:(NSNotification *)notice {
    [self resume];
}

#pragma mark - Init

- (void)setProgressColor:(UIColor *)progressColor {
    _progressColor = progressColor;
    self.frontFillLayer.strokeColor = progressColor.CGColor;
}

- (void)setProgressTrackColor:(UIColor *)progressTrackColor {
    _progressTrackColor = progressTrackColor;
    self.backGroundLayer.strokeColor = progressTrackColor.CGColor;
}

- (void)setProgressWidth:(CGFloat)progressWidth {
    _progressWidth = progressWidth;
    self.frontFillLayer.lineWidth = progressWidth;
    self.backGroundLayer.lineWidth = progressWidth;
}

- (void)configProgressLayer {
    self.backGroundLayer.frame = self.bounds;
    self.frontFillLayer.frame = self.bounds;
    
    center = CGPointMake(CGRectGetWidth(self.bounds)/2, CGRectGetHeight(self.bounds)/2);
    CGFloat radius = CGRectGetWidth(self.bounds) / 2.0f;
    
    self.backGroundBezierPath = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:0 endAngle:M_PI*2 clockwise:YES];
    self.backGroundLayer.path = self.backGroundBezierPath.CGPath;
    
    self.frontFillBezierPath = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:-M_PI_2 endAngle:1.5*M_PI clockwise:YES];
    self.frontFillLayer.path = self.frontFillBezierPath.CGPath;
    self.frontFillLayer.strokeStart = 0;
    self.frontFillLayer.strokeEnd = 0;
    
    [self.layer addSublayer:self.backGroundLayer];
    [self.layer addSublayer:self.frontFillLayer];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    [self configProgressLayer];
}

- (void)dealloc {
    if (self.timer) {
        [self.timer stopTimer];
        self.timer = nil;
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
