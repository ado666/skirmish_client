//
//  GameViewRow.h
//  skirmish
//
//  Created by Boris Kuznetsov on 15/12/15.
//  Copyright © 2015 Boris Kuznetsov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GameViewRow : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *game_id;
@property (weak, nonatomic) IBOutlet UILabel *game_enemy;

@end
