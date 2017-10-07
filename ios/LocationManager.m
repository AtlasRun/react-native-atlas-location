#import "LocationManager.h"
#import <React/RCTLog.h>

@implementation LocationManager

RCT_EXPORT_MODULE();

RCT_REMAP_METHOD(getRoughLocation,
                 resolver:(RCTPromiseResolveBlock)resolve
                 rejecter:(RCTPromiseRejectBlock)reject)
{
    // Belgium
    NSDictionary *loc = @{@"latitude": @50.5039, @"longitude": @4.4699};
    resolve(loc);
}

@end
