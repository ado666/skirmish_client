//
//  GameViewController.m
//  skirmish
//
//  Created by Boris Kuznetsov on 26/10/15.
//  Copyright © 2015 Boris Kuznetsov. All rights reserved.
//

#import "GameViewController.h"
#import "Networker.h"

#import "AppDelegate.h"
#import "Game.h"

@interface GameViewController ()
@property (weak, nonatomic) IBOutlet UILabel *question;

@property (weak, nonatomic) IBOutlet UILabel *answer1;
@property (weak, nonatomic) IBOutlet UILabel *answer2;
@property (weak, nonatomic) IBOutlet UILabel *answer3;
@property (weak, nonatomic) IBOutlet UILabel *answer4;
@property (weak, nonatomic) IBOutlet UIButton *answerButton1;
@property (weak, nonatomic) IBOutlet UIButton *answerButton2;
@property (weak, nonatomic) IBOutlet UIButton *answerButton3;
@property (weak, nonatomic) IBOutlet UIButton *answerButton4;
@end

@implementation GameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    Game *game = appDelegate.game;
    
    NSDictionary *question = game.questions[0];
    
    self.question.text = [question valueForKey:@"question"];
    self.answer1.text = [question valueForKey:@"answer1"];
    self.answer2.text = [question valueForKey:@"answer2"];
    self.answer3.text = [question valueForKey:@"answer3"];
    self.answer4.text = [question valueForKey:@"answer4"];
}

- (IBAction)answer:(id)sender {
    UIButton *button = (UIButton *)sender;
    
    NSString *answer;
    if (button == self.answerButton1){
        answer = @"1";
    }else if (button == self.answerButton2){
        answer = @"2";
    }else if (button == self.answerButton3){
        answer = @"3";
    }else if (button == self.answerButton4){
        answer = @"4";
    }
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    Game *game = appDelegate.game;
    Networker *net = appDelegate.networker;
    
    int step = [game.step intValue];
    NSDictionary *current_q = [game.questions objectAtIndex:step];
    
    NSString *gameId = game.gameId;
    NSString *qid = [current_q valueForKey:@"id"];
    
    NSDictionary *extra = [NSDictionary dictionaryWithObjectsAndKeys:qid,@"question_id",answer,@"answer_id",gameId,@"game_id", nil];
    
    NSDictionary *result = [net post:(NSString *)@"/game/answer" : (NSDictionary *) extra];
    
    NSDictionary *question = [game.questions objectAtIndex:step];
    
    self.question.text = [question valueForKey:@"question"];
    self.answer1.text = [question valueForKey:@"answer1"];
    self.answer2.text = [question valueForKey:@"answer2"];
    self.answer3.text = [question valueForKey:@"answer3"];
    self.answer4.text = [question valueForKey:@"answer4"];
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
