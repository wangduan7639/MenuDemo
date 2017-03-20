//
//  MenuView.m
//  MenuDemo
//
//  Created by wd on 2017/1/10.
//  Copyright © 2017年 wd. All rights reserved.
//

#import "MenuView.h"
#import "LeftMenuView.h"
#import "RightMenuView.h"

#define kMenuViewWidth 140

@interface MenuView()<UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIViewController *containerVC;
@property (nonatomic, strong) LeftMenuView *leftMenuView;
@property (nonatomic, strong) RightMenuView *rightMenuView;
@property (nonatomic, strong) UIView *maskView;

@end

@implementation MenuView

+ (instancetype)shareManager {
    static id menuView = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        menuView = [[self alloc] init];
    });
    return menuView;
}

- (instancetype)initWithContainerViewController:(UIViewController *)containerVC {
    if (self = [super init]) {
        _containerVC = containerVC;
        self.isLeftViewHidden = YES;
        self.isRightViewHidden = YES;
        _leftMenuView = [[LeftMenuView alloc] initWithFrame:CGRectMake(-kMenuViewWidth, 0, kMenuViewWidth, SCREEN_HEIGHT)];
        _rightMenuView = [[RightMenuView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH, 0, kMenuViewWidth, SCREEN_HEIGHT)];
        [_containerVC.navigationController.view addSubview:_leftMenuView];
        [_containerVC.navigationController.view addSubview:_rightMenuView];
        
        _maskView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _maskView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        _maskView.hidden = YES;
        [_containerVC.view addSubview:_maskView];
        
        [self addObserver:_leftMenuView forKeyPath:@"frame" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
        [self addObserver:_rightMenuView forKeyPath:@"frame" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
        [self addRecognizer];
    }
    return self;
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"frame"]) {
        CGRect new = [change[@"new"] CGRectValue];
        CGFloat x = new.origin.x;
        if (x != - kMenuViewWidth && x != SCREEN_WIDTH) {
            _maskView.hidden = NO;
        }else
        {
            _maskView.hidden = YES;
        }
    }
}

#pragma mark - UIPanGestureRecognizer
-(void)addRecognizer{
    
    UIPanGestureRecognizer *pan=[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(didPanEvent:)];
    pan.delegate = self;
    [_containerVC.view addGestureRecognizer:pan];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeMenuViewEvent:)];
    [self.maskView addGestureRecognizer:tap];
    
}

-(void)closeMenuViewEvent:(UITapGestureRecognizer *)recognizer{
    
    [self closeLeftView];
    [self closeRightView];
}

-(void)didPanEvent:(UIPanGestureRecognizer *)recognizer{
    
    CGPoint translation = [recognizer translationInView:_containerVC.view];
    //NSLog(@"translation.x == %f", translation.x);
    [recognizer setTranslation:CGPointZero inView:_containerVC.view];
    
    CGPoint startPoint = [recognizer locationInView:_containerVC.view];
    if (UIGestureRecognizerStateBegan == recognizer.state) {
        if (self.isLeftViewHidden == YES && self.isRightViewHidden == YES) {
            if (startPoint.x < SCREEN_WIDTH/2) { //右滑
                self.isLeftViewHidden = NO;
            }else {
                self.isRightViewHidden = NO;
            }
        }
    }else if(UIGestureRecognizerStateChanged == recognizer.state) {
        if (self.isLeftViewHidden == NO) {
            if (translation.x > 0 ) {//右滑
                
                if (self.leftMenuView.frame.origin.x == 0) {
                    return;
                }
                CGFloat tempX = self.leftMenuView.frame.origin.x + translation.x;
                if (tempX <= 0) {
                    
                    self.leftMenuView.frame = CGRectMake(tempX, 0, kMenuViewWidth, SCREEN_HEIGHT);
                    
                }else{
                    
                    self.leftMenuView.frame = CGRectMake(0, 0, kMenuViewWidth, SCREEN_HEIGHT);
                }
                
            }else{//左滑
                
                CGFloat tempX = self.leftMenuView.frame.origin.x + translation.x;
                self.leftMenuView.frame = CGRectMake(tempX, 0, kMenuViewWidth, SCREEN_HEIGHT);
            }

        }
        
        if (self.isRightViewHidden == NO) {
            if (translation.x > 0 ) {//右滑
                
                CGFloat tempX = self.rightMenuView.frame.origin.x + translation.x;
                self.rightMenuView.frame = CGRectMake(tempX, 0, kMenuViewWidth, SCREEN_HEIGHT);
        
            }else{//左滑
                
                if (self.rightMenuView.frame.origin.x >= SCREEN_WIDTH + kMenuViewWidth) {
                    return;
                }
                CGFloat tempX = self.rightMenuView.frame.origin.x + translation.x;
                if (tempX >= SCREEN_WIDTH-kMenuViewWidth) {
                    
                    self.rightMenuView.frame = CGRectMake(tempX, 0, kMenuViewWidth, SCREEN_HEIGHT);
                    
                }else{
                    
                    self.rightMenuView.frame = CGRectMake(SCREEN_WIDTH-kMenuViewWidth, 0, kMenuViewWidth, SCREEN_HEIGHT);
                }

            }

        }
    }else {
        if (self.isLeftViewHidden == NO) {
            if (self.leftMenuView.frame.origin.x >= - kMenuViewWidth * 0.5) {
                
                [self openLeftView];
                
            }else{
                
                [self closeLeftView];
            }

        }
        if (self.isRightViewHidden == NO) {
            if ((SCREEN_WIDTH - self.rightMenuView.frame.origin.x) >= kMenuViewWidth * 0.5) {
                
                [self openRightView];
                
            }else{
                
                [self closeRightView];
            }
        }
    }
    
}


- (void)openLeftView {
    [UIView animateWithDuration:0.3 animations:^{
        
        self.leftMenuView.frame = CGRectMake(0, 0, kMenuViewWidth, SCREEN_HEIGHT);
        self.isLeftViewHidden = NO;
    } completion:^(BOOL finished) {
        
        self.maskView.hidden = NO;
    }];
}

- (void)openRightView {
    [UIView animateWithDuration:0.3 animations:^{
        
        self.rightMenuView.frame = CGRectMake(SCREEN_WIDTH-kMenuViewWidth, 0, kMenuViewWidth, SCREEN_HEIGHT);
        self.isRightViewHidden = NO;
    } completion:^(BOOL finished) {
        
        self.maskView.hidden = NO;
    }];
}

- (void)closeLeftView {
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.leftMenuView.frame = CGRectMake(- kMenuViewWidth, 0, kMenuViewWidth, SCREEN_HEIGHT);
        self.isLeftViewHidden = YES;
        self.maskView.hidden = YES;
    }];

}

- (void)closeRightView {
    [UIView animateWithDuration:0.3 animations:^{
        
        self.rightMenuView.frame = CGRectMake( SCREEN_WIDTH, 0, kMenuViewWidth, SCREEN_HEIGHT);
        self.isRightViewHidden = YES;
        self.maskView.hidden = YES;
    }];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    
    if ([otherGestureRecognizer.view isKindOfClass:[UITableView class]]) {
        
        return NO;
    }
    
    return YES;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self removeObserver:self.leftMenuView forKeyPath:@"frame"];
    [self removeObserver:self.rightMenuView forKeyPath:@"frame"];
}

@end
