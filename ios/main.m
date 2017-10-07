#import "main.h"
#import <React/RCTLog.h>

@implementation CalendarManager

RCT_EXPORT_MODULE(CalendarManager);

RCT_EXPORT_METHOD(addEvent:(NSString *)name location:(NSString *)location)
{
//    [RCTLogInfo(@"Pretending to create an event %@ at %@", name, location);
    
     dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertView *av = [[UIAlertView alloc] init];
        av.message = location;
        [av show];
    });
}
@end
