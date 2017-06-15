//
//  PersonalCenterChildBaseVC.h
//  SGPageViewExample
//
//  Created by apple on 2017/6/15.
//  Copyright © 2017年 Sorgle. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol PersonalCenterChildBaseVCDelegate <NSObject>

- (void)personalCenterChildBaseVCScrollViewDidScroll:(UIScrollView *)scrollView;

@end

@interface PersonalCenterChildBaseVC : UIViewController
@property (nonatomic, weak) id<PersonalCenterChildBaseVCDelegate> delegatePersonalCenterChildBaseVC;
@end
