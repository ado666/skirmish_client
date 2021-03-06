//
//  GameNewController.m
//  skirmish
//
//  Created by Boris Kuznetsov on 16/12/15.
//  Copyright © 2015 Boris Kuznetsov. All rights reserved.
//

#import "GameNewController.h"
#import "AppDelegate.h"
#import "Game.h"
#import "User.h"

@interface GameNewController ()

@property (weak, nonatomic) IBOutlet UILabel *user1;
@property (weak, nonatomic) IBOutlet UILabel *user2;
@property (weak, nonatomic) IBOutlet UILabel *enemy_turn;
@property (weak, nonatomic) IBOutlet UIView *selectTheme;
@property (weak, nonatomic) IBOutlet UIView *Answer;
@property (weak, nonatomic) IBOutlet UIView *Result;

@end

@implementation GameNewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    Game *game = appDelegate.game;
    User *user = appDelegate.user;
    
    [game addObserver:self forKeyPath:@"players" options:NSKeyValueObservingOptionNew context:nil];
    [game addObserver:self forKeyPath:@"current_round" options:NSKeyValueObservingOptionNew context:nil];
    [game addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    
    self.user1.text = [[game valueForKey:@"players"][0] valueForKey:@"login"];
    self.user2.text = [[game valueForKey:@"players"][1] valueForKey:@"login"];
    
    NSDictionary* owner = [[game valueForKey:@"current_round"]valueForKey:@"turn"];
    
    NSDictionary *current_round = [game valueForKey:@"current_round"];
//    NSString *status = [game valueForKey:@"status"];
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    NSNumber *status = [f numberFromString:[game valueForKey:@"status"]];
//    NSLog(@"cr %@", game);
    if ([status isEqualToNumber:[NSNumber numberWithInt: -1]]){
        [self.selectTheme setHidden:YES];
        [self.Answer setHidden:YES];
        [self.enemy_turn setHidden:YES];
        [self.Result setHidden:NO];
    }
    else if ([[owner valueForKey:@"userId"] isEqualToNumber:[user valueForKey:@"userId"]]){
        [self.enemy_turn setHidden:YES];
        
//        NSLog(@"init %@", current_round);
        if ([current_round objectForKey:@"theme"] != [NSNull null]){
            [self.selectTheme setHidden:YES];
            [self.Answer setHidden:NO];
            [self.Result setHidden:YES];
        }else{
            [self.selectTheme setHidden:NO];
            [self.Result setHidden:YES];
            [self.Answer setHidden:YES];
        }
    }else{
        [self.enemy_turn setHidden:NO];
        [self.Result setHidden:YES];
        [self.selectTheme setHidden:YES];
        [self.Answer setHidden:YES];
    }
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    User *user = appDelegate.user;
    
    if ([keyPath isEqualToString:@"status"]){
        NSDictionary *data = [change valueForKey:@"new"];
        NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
        NSNumber *status = [f numberFromString:data];
        //    NSLog(@"cr %@", game);
        if ([status isEqualToNumber:[NSNumber numberWithInt: -1]]){
            [self.selectTheme setHidden:YES];
            [self.Answer setHidden:YES];
            [self.enemy_turn setHidden:YES];
            [self.Result setHidden:NO];
        }
    }
    if (([keyPath isEqualToString:@"current_round"])) {
        NSDictionary *data = [change valueForKey:@"new"];
        
        if ([[[data valueForKey:@"turn"] valueForKey:@"userId"] isEqualToNumber:[user valueForKey:@"userId"]]){
            [self.enemy_turn setHidden:YES];
//            NSLog(@"theme %@", data);
//            if ([data objectForKey:@"theme"] != NULL){
            if ([data objectForKey:@"theme"] != [NSNull null]){
//                NSLog(@"1");
                [self.selectTheme setHidden:YES];
                [self.Answer setHidden:NO];
                [self.Result setHidden:YES];
            }else{
//                NSLog(@"2");
                [self.selectTheme setHidden:NO];
                [self.Answer setHidden:YES];
                [self.Result setHidden:YES];
            }
        }else{
            [self.enemy_turn setHidden:NO];
            [self.selectTheme setHidden:YES];
            [self.Answer setHidden:YES];
            [self.Result setHidden:YES];
        }
    }
}

@end

