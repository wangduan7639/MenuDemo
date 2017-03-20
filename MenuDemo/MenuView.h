//
//  MenuView.h
//  MenuDemo
//
//  Created by wd on 2017/1/10.
//  Copyright © 2017年 wd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuView : NSObject

@property (nonatomic, assign) BOOL isLeftViewHidden;
@property (nonatomic, assign) BOOL isRightViewHidden;

+ (instancetype)shareManager;

- (instancetype)initWithContainerViewController:(UIViewController *)containerVC;

- (void)openLeftView;

- (void)openRightView;

- (void)closeLeftView;

- (void)closeRightView;

@end
