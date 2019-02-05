
#import "RNDrift.h"

#import "Drift/Drift.h"

@implementation RNDrift

- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}
RCT_EXPORT_MODULE()

RCT_EXPORT_METHOD(setup:(NSString *)id)
{
    RCTLogInfo(@"Configuring Drift for ReactNative");
    [Drift setup:@id];
}

RCT_EXPORT_METHOD(registerUser:(NSString *)id, email: (NSString *)email)
{
    RCTLogInfo(@"Registering a Drift user");
    [Drift registerUser:@id email:@email];
}

RCT_EXPORT_METHOD(logout)
{
    RCTLogInfo(@"Logout Drift user");
    [Drift logout];
}

RCT_EXPORT_METHOD(logout)
{
    RCTLogInfo(@"Logout Drift user");
    [Drift logout];
}

RCT_EXPORT_METHOD(showConversations)
{
    RCTLogInfo(@"Open Drift conversations");
    [Drift showConversations];
}

RCT_EXPORT_METHOD(showCreateConversation)
{
    RCTLogInfo(@"Open Drift new conversations");
    [Drift showCreateConversation];
}

@end
  
