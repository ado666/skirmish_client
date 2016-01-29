//
//  User.m
//  skirmish
//
//  Created by Boris Kuznetsov on 12/11/15.
//  Copyright © 2015 Boris Kuznetsov. All rights reserved.
//

#import "User.h"
#import "AppDelegate.h"
#import "Networker.h"

@interface User ()
//@property (weak, nonatomic) NSString *name;
//@property (weak, nonatomic) NSString *status;
//@property NSString name;

@end

@implementation User


@synthesize userId = _userId;
- (void) setUserId:(NSNumber *)userId {
    _userId = userId;
}
- (NSNumber*) userId {
    return _userId;
}

@synthesize login = _login;
- (void) setLogin:(NSString *)login {
    _login = login;
}
- (NSString*) login {
    return _login;
}

@synthesize status = _status;
- (void) setStatus:(NSNumber *)status {
//    NSLog(@"set status %@", status);
    _status = status;
}
- (NSNumber*) status {
    return _status;
}

// changed player
- (void) changed:(NSDictionary*) data {
    for (NSString* key in data){
        [self setValue:[data objectForKey:key] forKey:key];
    }
}

// need  refetch from seerver
- (void) needUpdate:(NSNumber *)entity_id{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    Networker *net = appDelegate.networker;
    NSDictionary* extra = [[NSDictionary alloc] init];
    [net post:(NSString *)@"/player/get" : (NSDictionary *) extra];
}

@end
