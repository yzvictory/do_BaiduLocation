//
//  do_BaiduLocation_SM.h
//  DoExt_SM
//
//  Created by guoxj on 15/4/8.
//  Copyright (c) 2015年 DoExt. All rights reserved.
//

#import "doSingletonModule.h"
#import "do_BaiduLocation_ISM.h"
#import "BMapKit.h"
@interface do_BaiduLocation_SM : doSingletonModule<do_BaiduLocation_ISM, BMKLocationServiceDelegate, BMKGeoCodeSearchDelegate>
@end