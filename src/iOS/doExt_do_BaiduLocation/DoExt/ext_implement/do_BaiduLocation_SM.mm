//
//  do_BaiduLocation_SM.m
//  DoExt_SM
//
//  Created by guoxj on 15/4/8.
//  Copyright (c) 2015年 DoExt. All rights reserved.
//

#import "do_BaiduLocation_SM.h"

#import "doScriptEngineHelper.h"
#import "doIScriptEngine.h"
#import "doInvokeResult.h"
#import "doJsonHelper.h"

@implementation do_BaiduLocation_SM
{
    BMKLocationService *_locService;
    BMKGeoCodeSearch *_geocodesearch;
    CLLocationCoordinate2D _coordinate;
    NSDictionary *_dictParas;
    id<doIScriptEngine> _scritEngine;
    NSString *_callbackName;
}

#pragma mark -
#pragma mark - 同步异步方法的实现
/*
 1.参数节点
     NSDictionary *_dictParas = [parms objectAtIndex:0];
     a.在节点中，获取对应的参数
     NSString *title = [doJsonHelper GetOneText: _dictParas :@"title" :@"" ];
     说明：第一个参数为对象名，第二为默认值
 
 2.脚本运行时的引擎
     id<doIScriptEngine> _scritEngine = [parms objectAtIndex:1];
 
 同步：
 3.同步回调对象(有回调需要添加如下代码)
     doInvokeResult *_invokeResult = [parms objectAtIndex:2];
     回调信息
     如：（回调一个字符串信息）
     [_invokeResult SetResultText:((doUIModule *)_model).UniqueKey];
 异步：
 3.获取回调函数名(异步方法都有回调)
     NSString *_callbackName = [parms objectAtIndex:2];
     在合适的地方进行下面的代码，完成回调
     新建一个回调对象
     doInvokeResult *_invokeResult = [[doInvokeResult alloc] init];
     填入对应的信息
     如：（回调一个字符串）
     [_invokeResult SetResultText: @"异步方法完成"];
     [_scritEngine Callback:_callbackName :_invokeResult];
 */
//同步
/**
 *停止定位
 */
 - (void)stop:(NSArray *)parms
 {
//     NSDictionary *_dictParas = [parms objectAtIndex:0];
//     id<doIScriptEngine> _scritEngine = [parms objectAtIndex:1];
//     //自己的代码实现
     [_locService stopUserLocationService];
 }
//异步
/**
 *启动定位服务
 */
- (void)getLocation:(NSArray *)parms
{
    _dictParas = [parms objectAtIndex:0];
    _scritEngine = [parms objectAtIndex:1];
    //自己的代码实现
    
    _callbackName = [parms objectAtIndex:2];
    NSString *_model = [doJsonHelper GetOneText: _dictParas :@"model" :@"gps" ];
    if ([_model isEqualToString:@"accuracy"])
    {
        [BMKLocationService setLocationDesiredAccuracy:kCLLocationAccuracyBest];
    }
    else if ([_model isEqualToString:@"lowpower"])
    {
        [BMKLocationService setLocationDesiredAccuracy:kCLLocationAccuracyThreeKilometers];
    }
    else
    {
        [BMKLocationService setLocationDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
    }
    
    [BMKLocationService setLocationDistanceFilter:1000.f];
    
    _locService = [[BMKLocationService alloc]init];
    _locService.delegate = self;
    [_locService startUserLocationService];
    _geocodesearch = [[BMKGeoCodeSearch alloc]init];
    _geocodesearch.delegate = self;
}

/**
 *用户方向更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    
}

/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    _coordinate.latitude  = userLocation.location.coordinate.latitude;
    _coordinate.longitude = userLocation.location.coordinate.longitude;
    BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
    reverseGeocodeSearchOption.reverseGeoPoint = _coordinate;
    
    BOOL flag = [_geocodesearch reverseGeoCode:reverseGeocodeSearchOption];
    if(flag)
    {
        NSLog(@"反geo检索发送成功");
    }
    else
    {
        NSLog(@"反geo检索发送失败");
    }
    
}

/**
 *在停止定位后，会调用此函数
 */
- (void)didStopLocatingUser
{
    
}

/**
 *定位失败后，会调用此函数
 *@param error 错误号
 */
- (void)didFailToLocateUserWithError:(NSError *)error
{
    
}

/**
 *返回地址信息搜索结果
 *@param searcher 搜索对象
 *@param result 搜索结BMKGeoCodeSearch果
 *@param error 错误号，@see BMKSearchErrorCode
 */
- (void)onGetGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    if (error == 0) {
        BMKPointAnnotation *_pointAnnotation = [[BMKPointAnnotation alloc]init];
        _pointAnnotation.coordinate = result.location;
        _pointAnnotation.title = result.address;
        
        NSMutableDictionary *_node = [[NSMutableDictionary alloc]init];;
        [_node setObject:[NSNumber numberWithFloat:_pointAnnotation.coordinate.latitude ] forKey:@"latitude"];
        [_node setObject:[NSNumber numberWithFloat:_pointAnnotation.coordinate.longitude ] forKey:@"longitude"];
        [_node setObject :_pointAnnotation.title forKey:@"address"];
        
        doInvokeResult *_invokeResult = [[doInvokeResult alloc] init:nil];
        [_invokeResult SetResultNode: _node];
        [_scritEngine Callback:_callbackName :_invokeResult];
    }
}

/**
 *返回反地理编码搜索结果
 *@param searcher 搜索对象
 *@param result 搜索结果
 *@param error 错误号，@see BMKSearchErrorCode
 */
-(void) onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    if (error == 0) {
        BMKPointAnnotation* _pointAnnotation = [[BMKPointAnnotation alloc]init];
        _pointAnnotation.coordinate = result.location;
        _pointAnnotation.title = result.address;
        NSMutableDictionary *_node = [[NSMutableDictionary alloc]init];
        [_node setObject:[NSNumber numberWithFloat:_pointAnnotation.coordinate.latitude ] forKey:@"latitude"];
        [_node setObject:[NSNumber numberWithFloat:_pointAnnotation.coordinate.longitude ] forKey:@"longitude"];
        [_node setObject :_pointAnnotation.title forKey:@"address"];
        
        doInvokeResult *_invokeResult = [[doInvokeResult alloc] init:nil];
        [_invokeResult SetResultNode: _node];
        [_scritEngine Callback:_callbackName :_invokeResult];
    }
}

- (void)Dispose
{
    _locService = nil;
    _geocodesearch = nil;
}

@end