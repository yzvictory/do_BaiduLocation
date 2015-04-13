//
//  do_BaiduLocation_SM.m
//  doDebuger
//
//  Created by guoxj on 15/4/8.
//  Copyright (c) 2015年 deviceone. All rights reserved.
//

#import "do_BaiduLocation_SM.h"
#import "doScriptEngineHelper.h"
#import "doIScriptEngine.h"
#import "doInvokeResult.h"
#import "doJsonNode.h"

@implementation do_BaiduLocation_SM
{
    BMKLocationService *_locService;
    BMKGeoCodeSearch *_geocodesearch;
    CLLocationCoordinate2D _coordinate;
    doJsonNode *_dictParas;
    id<doIScriptEngine> _scritEngine;
    NSString *_callbackName;
}        

- (void)getLocation:(NSArray *)parms
{
    _dictParas = [parms objectAtIndex:0];
    _scritEngine = [parms objectAtIndex:1];
    _callbackName = [parms objectAtIndex:2];
    NSString *_model = [_dictParas GetOneText:@"model" :@"gps" ];
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

- (void)stop
{
    [_locService stopUserLocationService];
}

- (void)willStartLocatingUser
{

}

- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    
}

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

- (void)didStopLocatingUser
{
    
}

- (void)didFailToLocateUserWithError:(NSError *)error
{
    
}


- (void)onGetGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    if (error == 0) {
        BMKPointAnnotation *_pointAnnotation = [[BMKPointAnnotation alloc]init];
        _pointAnnotation.coordinate = result.location;
        _pointAnnotation.title = result.address;
        
        doJsonNode *_node = [[doJsonNode alloc]init];
        [_node SetOneText:@"latitude" :[NSString stringWithFormat:@"%f",_pointAnnotation.coordinate.latitude]];
        [_node SetOneText:@"longitude" :[NSString stringWithFormat:@"%f",_pointAnnotation.coordinate.longitude]];
        [_node SetOneText:@"address" :_pointAnnotation.title];
        
        doInvokeResult *_invokeResult = [[doInvokeResult alloc] init:nil];
        [_invokeResult SetResultNode: _node];
        [_scritEngine Callback:_callbackName :_invokeResult];
    }
}

-(void) onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    if (error == 0) {
        BMKPointAnnotation* _pointAnnotation = [[BMKPointAnnotation alloc]init];
        _pointAnnotation.coordinate = result.location;
        _pointAnnotation.title = result.address;
        doJsonNode *_node = [[doJsonNode alloc]init];
        [_node SetOneText:@"latitude" :[NSString stringWithFormat:@"%f",_pointAnnotation.coordinate.latitude]];
        [_node SetOneText:@"longitude" :[NSString stringWithFormat:@"%f",_pointAnnotation.coordinate.longitude]];
        [_node SetOneText:@"address" :_pointAnnotation.title];
        
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
