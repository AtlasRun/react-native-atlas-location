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
  NSTimeInterval startTime;
  NSTimeInterval lastLocTimestamp;
}

RCT_EXPORT_MODULE();

-(instancetype)init
{
    self = [super init];
    if (self) {
        loc = [CLLocationManager new];
        lastLocTimestamp = -1;
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
    startTime = [[NSDate new] timeIntervalSince1970];
    // Belgium
    if (hasListeners) {
      [self sendEventWithName:EVENT_TRACKING_STARTED body:@{}];
      loc.activityType = CLActivityTypeFitness;
      [loc setAllowsBackgroundLocationUpdates:YES];
      [loc setDistanceFilter:kCLDistanceFilterNone];
      [loc setDesiredAccuracy:kCLLocationAccuracyBest];
      [loc requestWhenInUseAuthorization];
      [loc setPausesLocationUpdatesAutomatically: NO];
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
    
    NSTimeInterval timestamp = [point.timestamp timeIntervalSince1970];
    
    // Ignore points collected before the start
    if (timestamp < startTime) { return; }
    
    // Ignore duplicates *exact* duplicates (Bug in iOS? Or RN is calling startTwice...)
    double diff = ABS(timestamp - lastLocTimestamp);
    if (diff < 0.01) { return; }
    lastLocTimestamp = timestamp;
    
    [self sendEventWithName:EVENT_TRACKING_POSITION_UPDATED body:@{
                                                                   @"latitude": @(point.coordinate.latitude),
                                                                   @"longitude": @(point.coordinate.longitude),
                                                                   @"horizontalAccuracy": @(point.horizontalAccuracy),
                                                                   @"timestamp": @(timestamp),
                                                                   @"howRecent": @([point.timestamp timeIntervalSinceNow]),
                                                                   @"speed": @(point.speed),
                                                                   }];
}

@end
