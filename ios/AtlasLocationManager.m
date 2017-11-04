#import "AtlasLocationManager.h"
#import <React/RCTLog.h>

static NSString *const EVENT_TRACKING_POSITION_UPDATED    = @"trackingPositionUpdated";
static NSString *const EVENT_TRACKING_STARTED    = @"trackingStarted";
static NSString *const EVENT_TRACKING_STOPPED    = @"trackingStopped";

@implementation AtlasLocationManager

RCT_EXPORT_MODULE();

// Events we support
- (NSArray<NSString *> *)supportedEvents {
    return @[
      EVENT_TRACKING_STARTED,
      EVENT_TRACKING_STOPPED,
      EVENT_TRACKING_POSITION_UPDATED,
    ];
}

RCT_REMAP_METHOD(getRoughLocation,
                 getRoughLocationWithResolver:(RCTPromiseResolveBlock)resolve
                 rejecter:(RCTPromiseRejectBlock)reject)
{
    // Belgium
    NSDictionary *loc = @{@"latitude": @50.5039, @"longitude": @4.4699};
    resolve(loc);
}

RCT_REMAP_METHOD(startTracking,
                 startTrackingWithResolver:(RCTPromiseResolveBlock)resolve
                 rejecter:(RCTPromiseRejectBlock)reject)
{
    // Belgium
    [self sendEventWithName:EVENT_TRACKING_STARTED body:@{}];
    resolve(0);
}

// Clears all onPositionUpdate(s)
RCT_REMAP_METHOD(stopTracking,
                 stopTrackingWithResolver:(RCTPromiseResolveBlock)resolve
                 rejecter:(RCTPromiseRejectBlock)reject)
{
    [self sendEventWithName:EVENT_TRACKING_STOPPED body:@{}];
    resolve(0);
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
