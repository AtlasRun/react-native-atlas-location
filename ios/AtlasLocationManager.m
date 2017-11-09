#import "AtlasLocationManager.h"
#import <React/RCTLog.h>
#import <CoreLocation/CoreLocation.h>

static NSString *const EVENT_TRACKING_POSITION_UPDATED    = @"trackingPositionUpdated";
static NSString *const EVENT_TRACKING_STARTED    = @"trackingStarted";
static NSString *const EVENT_TRACKING_STOPPED    = @"trackingStopped";

@implementation AtlasLocationManager
{
  bool hasListeners;
    
  CLLocationManager *loc;
}

RCT_EXPORT_MODULE();

-(instancetype)init
{
    self = [super init];
    if (self) {
        loc = [CLLocationManager new];
        [loc setDelegate:self];
    }

    return self;
}

// Will be called when this module's first listener is added.
-(void)startObserving {
    hasListeners = YES;
    // Set up any upstream listeners or background tasks as necessary
}

// Will be called when this module's last listener is removed, or on dealloc.
-(void)stopObserving {
    hasListeners = NO;
    // Remove upstream listeners, stop unnecessary background tasks
}

// Events we support
- (NSArray<NSString *> *)supportedEvents {
    return @[
      EVENT_TRACKING_STARTED, EVENT_TRACKING_STOPPED, EVENT_TRACKING_POSITION_UPDATED,
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
    if (hasListeners) {
      [self sendEventWithName:EVENT_TRACKING_STARTED body:@{}];
        loc.desiredAccuracy = kCLLocationAccuracyBest;
      loc.activityType = CLActivityTypeFitness;
      [loc setAllowsBackgroundLocationUpdates:YES];
      [loc setDistanceFilter:kCLDistanceFilterNone];
      [loc requestWhenInUseAuthorization];
      [loc startUpdatingLocation];
    }
    resolve(0);
}

// Clears all onPositionUpdate(s)
RCT_REMAP_METHOD(stopTracking,
                 stopTrackingWithResolver:(RCTPromiseResolveBlock)resolve
                 rejecter:(RCTPromiseRejectBlock)reject)
{
    if (hasListeners) {
      [self sendEventWithName:EVENT_TRACKING_STOPPED body:@{}];
    }

    [loc stopUpdatingLocation];
    resolve(0);
}
    
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    CLLocation *point = locations.lastObject;
    [self sendEventWithName:EVENT_TRACKING_POSITION_UPDATED body:@{
                                                                   @"latitude": @(point.coordinate.latitude),
                                                                   @"longitude": @(point.coordinate.longitude),
                                                                   @"horizontalAccuracy": @(point.horizontalAccuracy),
                                                                   @"timestamp": @([point.timestamp timeIntervalSince1970]),
                                                                   @"speed": @(point.speed),
                                                                   }];
}

@end
