//
//  FlipsideViewController.h
//  project2
//
//  Created by James Chou on 3/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FlipsideViewController;

@protocol FlipsideViewControllerDelegate
- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller;
@end

@interface FlipsideViewController : UIViewController

@property (weak, nonatomic) id <FlipsideViewControllerDelegate> delegate;
@property (nonatomic, weak) IBOutlet UISwitch *evilSwitch;
@property (nonatomic, weak) IBOutlet UILabel *wordLengthLabel;
@property (nonatomic, weak) IBOutlet UILabel *maxGuessLabel;
@property (nonatomic, weak) IBOutlet UISlider *wordLength;
@property (nonatomic, weak) IBOutlet UISlider *maxGuess;
@property (weak, nonatomic) IBOutlet UILabel *highScores;

- (IBAction)done:(id)sender;
- (IBAction)evilToggle:(id)sender;
- (IBAction)adjustWordLength:(id)sender;
- (IBAction)adjustMaxGuess:(id)sender;


@end
