//
//  LobbyNewController.m
//  skirmish
//
//  Created by Boris Kuznetsov on 03/12/15.
//  Copyright © 2015 Boris Kuznetsov. All rights reserved.
//

#import "AppDelegate.h"
#import "Constants.h"

#import "LobbyNewController.h"
#import "GameFactory.h"
#import "Game.h"
#import "User.h"

#import "GameViewRow.h"

@interface LobbyNewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *gameList;
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UIButton *status;
@property (weak, nonatomic) IBOutlet UIButton *actionButton;
@property (weak, nonatomic) IBOutlet UIButton *exitButton;

@property (weak, nonatomic) NSString *prefix;

@end

@implementation LobbyNewController

NSArray *games;
@synthesize tableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.prefix = @"Привет, ";
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    User *user = appDelegate.user;
    
    self.username.text = [self.prefix stringByAppendingString:user.login];
    if ([user.status isEqualToNumber:[[NSNumber alloc] initWithDouble:PLAYER_STATUS_ONLINE]]){
        [self.actionButton setTitle:@"НАЙТИ ИГРУ" forState:UIControlStateNormal];
    }else if ([user.status isEqualToNumber:[[NSNumber alloc] initWithDouble:PLAYER_STATUS_LOOKING]]){
        [self.actionButton setTitle:@"ОТМЕНИТЬ ПОИСК" forState:UIControlStateNormal];
    }

    [user addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateGames:) name:@"entities" object:nil];
    [self updateGames:[NSNotification alloc]];
}

- (NSIndexPath*)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    Game *game = appDelegate.game;
    
    NSInteger *index = indexPath.row;
//    NSLog(@" %@", indexPath);
//    return indexPath;
//    int index = [indexPath.row integerValue];
    NSDictionary *current = [games objectAtIndex:index];
    
    [game setGameId:[current valueForKey:@"id"]];
    
    return indexPath;
}


- (void) updateGames:(NSNotification *) note{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    GameFactory *gf = appDelegate.gameFactory;
    
    NSMutableArray *temp = [[NSMutableArray alloc] init];
    
    for (id object in gf.entities){
        NSDictionary *item = [gf.entities valueForKey:object];
        [temp addObject: item];
    }
    
    NSArray *array = [temp sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        NSDate *first = [a valueForKey:@"id"];
        NSDate *second = [b valueForKey:@"id"];
        return [second compare:first];
    }];
    
    games = array;
    [self.gameList reloadData];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    
//    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//    User *user = appDelegate.user;
    
    if ([keyPath isEqualToString:@"status"]) {
        if ([[change valueForKey:@"new"] isEqualToNumber:[[NSNumber alloc] initWithDouble:PLAYER_STATUS_ONLINE]]){
            [self.actionButton setTitle:@"НАЙТИ ИГРУ" forState:UIControlStateNormal];
        }else if ([[change valueForKey:@"new"] isEqualToNumber:[[NSNumber alloc] initWithDouble:PLAYER_STATUS_LOOKING]]){
            [self.actionButton setTitle:@"ОТМЕНИТЬ ПОИСК" forState:UIControlStateNormal];
        }
    }
}

- (IBAction)subscribe:(id)sender {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    User *user = appDelegate.user;
    Networker *net = appDelegate.networker;
    
    if ([[user valueForKey:@"status"] isEqualToNumber:[[NSNumber alloc] initWithDouble:PLAYER_STATUS_ONLINE]]){
        [net post:(NSString *)@"/player/subscribe" : [[NSDictionary alloc] init]];
    }else if ([[user valueForKey:@"status"] isEqualToNumber:[[NSNumber alloc] initWithDouble:PLAYER_STATUS_LOOKING]]){
        [net post:(NSString *)@"/player/unsubscribe" : [[NSDictionary alloc] init]];
    }
}

- (IBAction)logout:(id)sender {
    UIApplication *app = [[UIApplication sharedApplication] delegate];
    Networker *net = [app valueForKey:@"networker"];
    
    [net post:@"/player/logout" :[[NSDictionary alloc] init]];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [games count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    User *user = appDelegate.user;
    static NSString *simpleTableIdentifier = @"game_row";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    UILabel *game_id = (UILabel *)[cell.contentView viewWithTag:1];
    UILabel *game_enemy = (UILabel *)[cell.contentView viewWithTag:2];
    UILabel *game_status = (UILabel *)[cell.contentView viewWithTag:3];
    game_id.text = [[games objectAtIndex:indexPath.row] valueForKey:@"id"];
    game_status.text = [[games objectAtIndex:indexPath.row] valueForKey:@"status"];
    
    NSArray *players = [[games objectAtIndex:indexPath.row] valueForKey:@"players"];
    
    NSString *enemy;
    for (id player in players){
        if ([[player valueForKey:@"userId"] isEqualToNumber:user.userId]){
        }else{
            enemy = [player valueForKey:@"login"];
        }
    }
    game_enemy.text = enemy;
    
    
//    NSLog(@"ssss %@", [[games objectAtIndex:indexPath.row] valueForKey:@"players"]);

//    cell.textLabel.text = [games objectAtIndex:indexPath.row];
//    cell.game_id.text = @"asd";
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
