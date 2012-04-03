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
@property (nonatomic, assign) int maxGuesses;
@property (nonatomic, assign) int remainingGuesses;


@property (nonatomic, weak) IBOutlet UILabel* label;
@property (nonatomic, weak) IBOutlet UITextField* textField;
@property (nonatomic, weak) IBOutlet UIButton* button;
@property (nonatomic, weak) IBOutlet UIProgressView* progress;


- (IBAction)showInfo:(id)sender;
- (IBAction)startGame:(id)sender;
- (IBAction)play:(id)sender;

@end
