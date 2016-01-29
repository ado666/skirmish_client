//
//  SelectTheme.m
//  skirmish
//
//  Created by Boris Kuznetsov on 02/01/16.
//  Copyright © 2016 Boris Kuznetsov. All rights reserved.
//

#import "SelectTheme.h"
#import "AppDelegate.h"
#import "Game.h"

@interface SelectTheme() <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *selectTheme;

@end

NSArray *themes;
@implementation SelectTheme

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateThemes:) name:@"entities" object:nil];
//    themes = [[NSArray alloc] initWithObjects:@"asd", @"dsa", nil];
    [self updateThemes:[NSNotification alloc]];
    
    
//    [self.selectTheme reloadData];
}

- (void) updateThemes :(NSNotification*) note{
    [self.selectTheme reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    return [themes count];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    Game *game = appDelegate.game;
    
    NSDictionary* cu = [game valueForKey:@"current_round"];
    return [[cu valueForKey:@"themes"] count];
}

- (NSIndexPath*)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    Game *game = appDelegate.game;

    [game selectTheme:indexPath.row+1];
    
    return indexPath;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *simpleTableIdentifier = @"themeRow";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    UILabel *theme = (UILabel *)[cell.contentView viewWithTag:1];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    Game *game = appDelegate.game;
    
    NSDictionary* cu = [game valueForKey:@"current_round"];
//    NSLog(@"sssss %@", [[cu valueForKey:@"themes"] objectAtIndex:indexPath]);
    
    theme.text = [[cu valueForKey:@"themes"][indexPath.row] valueForKey:@"title"];
    
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
//    }
    
//    UILabel *game_id = (UILabel *)[cell.contentView viewWithTag:1];
//    UILabel *game_enemy = (UILabel *)[cell.contentView viewWithTag:2];
//    UILabel *game_status = (UILabel *)[cell.contentView viewWithTag:3];
//    game_id.text = [[games objectAtIndex:indexPath.row] valueForKey:@"id"];
//    game_status.text = [[games objectAtIndex:indexPath.row] valueForKey:@"status"];
//    
//    NSArray *players = [[games objectAtIndex:indexPath.row] valueForKey:@"players"];
//    
//    NSString *enemy;
//    for (id player in players){
//        if ([[player valueForKey:@"userId"] isEqualToNumber:user.userId]){
//        }else{
//            enemy = [player valueForKey:@"login"];
//        }
//    }
//    game_enemy.text = enemy;
//    
//    
//    //    NSLog(@"ssss %@", [[games objectAtIndex:indexPath.row] valueForKey:@"players"]);
//    
//    //    cell.textLabel.text = [games objectAtIndex:indexPath.row];
    //    cell.game_id.text = @"asd";
    return cell;
}


@end
