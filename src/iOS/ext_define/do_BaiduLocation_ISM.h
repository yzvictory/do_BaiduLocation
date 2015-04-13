//
//  do_BaiduLocation_ISM.h
//  doDebuger
//
//  Created by guoxj on 15/4/8.
//  Copyright (c) 2015年 deviceone. All rights reserved.
//
#import <Foundation/Foundation.h>

@protocol do_BaiduLocation_ISM <NSObject>
@required
- (void)getLocation: (NSArray *)parms;
- (void)stop;
@end
