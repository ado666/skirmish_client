//
//  Networker.h
//  skirmish
//
//  Created by Boris Kuznetsov on 30/09/15.
//  Copyright © 2015 Boris Kuznetsov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Networker : NSObject

- (NSString*) dictToString: (NSDictionary*) data;

- (NSDictionary*) get :(NSString*)url :(NSDictionary*)extra;
- (NSDictionary*) post :(NSString*)url :(NSDictionary*)extra;

@end
