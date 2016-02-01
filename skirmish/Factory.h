//
//  Factory.h
//  skirmish
//
//  Created by Boris Kuznetsov on 02/12/15.
//  Copyright © 2015 Boris Kuznetsov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Factory : NSObject

@property (nonatomic) NSString* url;
@property (nonatomic) NSMutableDictionary* entities;

- (void) all: (NSArray*)data;
- (void) changed :(NSNumber*) entityId;
- (void) changedData :(NSDictionary*) data;
- (NSDictionary*) get :(NSNumber*) entityId;

@end
