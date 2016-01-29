//
//  LobbyNewController.h
//  skirmish
//
//  Created by Boris Kuznetsov on 03/12/15.
//  Copyright © 2015 Boris Kuznetsov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LobbyNewController : UIViewController

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSNumber *selectedGame;

@end
