//
//  MainViewController.h
//  project2
//
//  Created by James Chou on 3/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FlipsideViewController.h"

@protocol StrategyDelegate

- (NSMutableArray*)playLetter:(NSString*)letter withArray:(NSMutableArray*)array;

@end

@interface MainViewController : UIViewController <FlipsideViewControllerDelegate>

@property (nonatomic, strong) NSMutableDictionary *sortedWords;
@property (nonatomic, strong) NSMutableArray *activeWords;

- (IBAction)showInfo:(id)sender;
- (void)startGame;
- (void)playLetter:(NSString*)letter;

@end
