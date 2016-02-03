//
//  Networker.m
//  skirmish
//
//  Created by Boris Kuznetsov on 30/09/15.
//  Copyright © 2015 Boris Kuznetsov. All rights reserved.
//

#import "Networker.h"
#import "AppDelegate.h"
#import "User.h"

@implementation Networker

- (NSString*) dictToString: (NSDictionary*) data
{
    NSString *extraString = @"";
    for (NSString* key in data) {
        id value = [data objectForKey:key];
//        NSString *strvalue = (NSString *)value;
        NSString *strvalue = [[NSString alloc] initWithString:value];
        NSLog(@"asd %i", [strvalue isKindOfClass:[NSString class]]);
        extraString = [extraString stringByAppendingString:key];
        extraString = [extraString stringByAppendingString:@"="];
        extraString = [extraString stringByAppendingString:strvalue];
        extraString = [extraString stringByAppendingString:@"&"];
    }
    return extraString;
}

-(NSDictionary*) get: (NSString*)url :(NSDictionary *)extra
{
    UIApplication *app = [[UIApplication sharedApplication] delegate];
    NSString *dtoken = [NSString stringWithFormat:@"%@", [app valueForKey:@"device_token"]];
    url = [@"http://91.225.238.186:10000" stringByAppendingString:url];
    
    NSString *extraString = [self dictToString: extra];
    extraString = [extraString stringByAppendingString:@"push_id="];
    extraString = [extraString stringByAppendingString:dtoken];
    
    NSError *error = nil; NSURLResponse *response = nil;
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"POST"];
    
    [request setValue:@"application/x-www-form-urlencoded;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    [request setHTTPBody:[extraString dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data
                                                         options:kNilOptions
                                                           error:&error];
    
    NSDictionary* income_data = [json objectForKey:@"data"];
    
    return income_data;
}

-(NSDictionary*) post: (NSString*)url :(NSDictionary *)extra
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSString *dtoken = [NSString stringWithFormat:@"%@", [appDelegate valueForKey:@"device_token"]];
    
    url = [@"http://91.225.238.186:10000" stringByAppendingString:url];
    
    NSString *extraString = [self dictToString: extra];
    extraString = [extraString stringByAppendingString:@"push_id="];
    extraString = [extraString stringByAppendingString:dtoken];

    NSError *error = nil; NSURLResponse *response = nil;
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"POST"];
    
    [request setValue:@"application/x-www-form-urlencoded;charset=utf-8" forHTTPHeaderField:@"Content-Type"];

    [request setHTTPBody:[extraString dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data
                                                         options:kNilOptions
                                                           error:&error];
    
    
//    NSLog(@"post response %@", json);
    
    NSString *status        = [json objectForKey:@"status"];
    NSDictionary *result    = [json objectForKey:@"result"];
    NSDictionary *payload   = [json objectForKey:@"payload"];
    
    if ([payload objectForKey:@"player"]){
        [appDelegate.user changed:[payload objectForKey:@"player"]];
    }
    
    if ([payload objectForKey:@"games"]){
        [appDelegate.gameFactory all:[payload objectForKey:@"games"]];
//        [appDelegate.gameFactory setValue:[payload objectForKey:@"games"] forKey:@"entities"];
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"entities" object:nil];
    }
    
    if ([payload objectForKey:@"game"]){
//        NSLog(@"payload game %@", payload);
        NSDictionary* game = [payload objectForKey:@"game"];
        [appDelegate.gameFactory changedData:game];
        
//        [appDelegate.game setQuestions:[game valueForKey:@"questions"]];
//        [appDelegate.game setStep:[game valueForKey:@"step"]];
        
//        [appDelegate.game setTurn:[game valueForKey:@"turn"]];
//        [appDelegate.game setRounds:[game valueForKey:@"rounds"]];
//        [appDelegate.game setCurrent_round:[game valueForKey:@"current_round"]];
        appDelegate.game.gameId = [game valueForKey:@"id"];
    }
    
    return result;
    
    return [[NSDictionary alloc] init];
    
    NSDictionary* income_data = [json objectForKey:@"data"];
    
//    [appDelegate.user setName:[income_data valueForKey:@"username"]];
//    [appDelegate.user setStatus:[income_data valueForKey:@"status"]];
    [appDelegate.user setUserId:[income_data valueForKey:@"userId"]];
    
    NSDictionary* game = [income_data objectForKey:@"game"];
    
    if (game){
        [appDelegate.game setQuestions:[game valueForKey:@"questions"]];
//        [appDelegate.game setStep:[game valueForKey:@"step"]];
        [appDelegate.game setGameId:[game valueForKey:@"id"]];
        [appDelegate.game setTurn:[game valueForKey:@"turn"]];
//        [appDelegate.game setStatus:(int)[game valueForKey:@"status"]];
    }
    
//    NSLog(@"--- %@", income_data);
//    NSLog(@" %@ %@", [game valueForKey:@"turn"], appDelegate.user.userId);
    
//    if ([[game valueForKey:@"turn"] isEqualToString:@"1"]){
//        NSLog(@"11");
//    }
//    NSLog(@"aaaa %@ ", appDelegate.user.userId);
//    if ([appDelegate.user.userId isEqualToString:appDelegate.user.userId]){
//        NSLog(@"22");
//    }
    
    if ([[income_data valueForKey:@"status"]  isEqual: @"looking"])
    {
        [appDelegate openView:@"LobbyView"];
    }
    if ([[income_data valueForKey:@"status"]  isEqual: @"online"])
    {
        [appDelegate openView:@"LobbyView"];
    }
    if ([[income_data valueForKey:@"status"]  isEqual: @"offline"])
    {
        [appDelegate openView:@"LoginView"];
    }
    if ([[income_data valueForKey:@"status"]  isEqual: @"ingame"])
    {
//        NSLog(@"--- %@ %@ ", appDelegate.game.turn, appDelegate.user.userId);
//        if ([appDelegate.game.turn isEqualToString:appDelegate.user.userId]){
            [appDelegate openView:@"GameView"];
//        }else{
//            [appDelegate openView:@"EnemyView"];
//        }
        
    }
    if ([[income_data valueForKey:@"status"]  isEqual: @"enemy_turn"])
    {
        [appDelegate openView:@"EnemyView"];
        
    }
    
    [appDelegate openView:@"LobbyNewView"];
    
    return json;
}

@end

