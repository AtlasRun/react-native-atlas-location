#import "LocationManager.h"
#import <React/RCTLog.h>

static NSString *const EVENT_TRACKING_POSITION_UPDATED    = @"trackingPositionUpdated";
static NSString *const EVENT_TRACKING_STARTED    = @"trackingStarted";
static NSString *const EVENT_TRACKING_STOPPED    = @"trackingStopped";

@implementation AtlasLocationManager

RCT_EXPORT_MODULE();

RCT_REMAP_METHOD(getRoughLocation,
                 resolver:(RCTPromiseResolveBlock)resolve
                 rejecter:(RCTPromiseRejectBlock)reject)
{
    // Belgium
    NSDictionary *loc = @{@"latitude": @50.5039, @"longitude": @4.4699};
    resolve(loc);
}

RCT_REMAP_METHOD(startTracking,
                 resolver:(RCTPromiseResolveBlock)resolve
                 rejecter:(RCTPromiseRejectBlock)reject)
{
    // Belgium
    [self sendEvent:EVENT_TRACKING_STARTED body:@{}];
    resolve();
}

// Clears all onPositionUpdate(s)
RCT_REMAP_METHOD(stopTracking,
                 resolver:(RCTPromiseResolveBlock)resolve
                 rejecter:(RCTPromiseRejectBlock)reject)
{
    [self sendEvent:EVENT_TRACKING_STOPPED body:@{}];
    resolve();
}

//RCT_EXPORT_METHOD(onPositionUpdate:(RCTResponseSenderBlock)onUpdate)
//{
//    [locationManager watchPosition:options success:^(TSLocation* location) {
//        [self sendEvent:EVENT_WATCHPOSITION body:[location toDictionary]];
//    } failure:^(NSError* error) {
//        [self sendEvent:EVENT_ERROR body:@{@"type":@"location", @"code":@(error.code)}];
//    }];
//    success(@[]);
//}

@end
