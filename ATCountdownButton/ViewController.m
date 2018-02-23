//
//  ViewController.m
//  ATCountdownButton
//
//  Created by Attu on 2018/2/23.
//  Copyright © 2018年 Attu. All rights reserved.
//

#import "ViewController.h"
#import "ATCountdownButton.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet ATCountdownButton *buttonOne;
@property (nonatomic, strong) ATCountdownButton *buttonTwo;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.buttonOne.layer.cornerRadius = 35.0f;
    self.buttonOne.layer.masksToBounds = YES;
    
    self.buttonOne.progressColor = [UIColor blueColor];
    self.buttonOne.progressTrackColor = [UIColor lightGrayColor];
    self.buttonOne.progressWidth = 5.0f;
    
    self.buttonTwo = [[ATCountdownButton alloc] initWithFrame:CGRectMake(240, 143, 70, 70)];
    self.buttonTwo.backgroundColor = [UIColor lightGrayColor];
    [self.buttonTwo addTarget:self action:@selector(onClickButtonOne:) forControlEvents:UIControlEventTouchUpInside];
    
    self.buttonTwo.layer.cornerRadius = 35.0f;
    self.buttonTwo.layer.masksToBounds = YES;
    
    self.buttonTwo.progressWidth = 5.0f;
    [self.view addSubview:self.buttonTwo];
}

- (IBAction)onClickButtonOne:(ATCountdownButton *)sender {
    [sender startWithDuration:5.0f block:^(CGFloat time) {
        NSLog(@"当前时间: %f", time);
    } completion:^(BOOL finished) {
        NSLog(@"倒计时结束");
    }];
}

- (void)onClickButtonTwo:(ATCountdownButton *)sender {
    [sender startWithDuration:5.0f block:^(CGFloat time) {
        NSLog(@"当前时间: %f", time);
    } completion:^(BOOL finished) {
        NSLog(@"倒计时结束");
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
