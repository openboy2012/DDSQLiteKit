//
//  DDSqliteViewController.h
//  DDKit
//
//  Created by Diaoshu on 14-12-21.
//  Copyright (c) 2014年 Dejohn Dong. All rights reserved.
//

#import <UIKit/UIKit.h>

// 版本号
#ifndef OS_VERSION
#define OS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]
#endif

#define VERSION_GREATER(x) (OS_VERSION > x) ? 1 : 0

@interface DDSqliteViewController : UIViewController

@end
