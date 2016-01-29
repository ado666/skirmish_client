//
//  User.h
//  skirmish
//
//  Created by Boris Kuznetsov on 12/11/15.
//  Copyright © 2015 Boris Kuznetsov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject
@property (nonatomic) NSString* login;
@property (nonatomic) NSNumber* status;
@property (nonatomic) NSNumber* userId;

- (void) changed: (NSDictionary*)data;
- (void) needUpdate: (NSNumber*)entity_id;

@end
