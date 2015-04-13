//
//  do_BaiduLocation_SM.h
//  doDebuger
//
//  Created by guoxj on 15/4/8.
//  Copyright (c) 2015年 deviceone. All rights reserved.
//

#import "doSingletonModule.h"
#import "do_BaiduLocation_ISM.h"
#import "BMapKit.h"
@interface do_BaiduLocation_SM : doSingletonModule<do_BaiduLocation_ISM, BMKLocationServiceDelegate, BMKGeoCodeSearchDelegate>
@end
