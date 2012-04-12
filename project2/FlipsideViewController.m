//
//  FlipsideViewController.m
//  project2
//
//  Created by James Chou on 3/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FlipsideViewController.h"

@interface FlipsideViewController ()

@end

@implementation FlipsideViewController

@synthesize delegate = _delegate;
@synthesize evilSwitch = _evilSwitch;
@synthesize wordLengthLabel = _wordLengthLabel;
@synthesize maxGuessLabel = _maxGuessLabel;
@synthesize maxGuess = _maxGuess;
@synthesize wordLength = _wordLength;

- (void)viewDidLoad {
  [super viewDidLoad];

  // load saved settings and update the UI
  self.evilSwitch.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"evilMode"];
  int wordLengthInt = [[NSUserDefaults standardUserDefaults] integerForKey:@"wordLength"];
  self.wordLength.value = (float) wordLengthInt;
  self.wordLengthLabel.text = [NSString stringWithFormat:@"%d letters", wordLengthInt]; 
  self.wordLength.maximumValue = (float) [[NSUserDefaults standardUserDefaults] integerForKey:@"maxWordLength"];
  int maxGuessInt = [[NSUserDefaults standardUserDefaults] integerForKey:@"maxGuesses"];
  self.maxGuess.value = (float) maxGuessInt;
  self.maxGuessLabel.text = [NSString stringWithFormat:@"%d guesses", maxGuessInt]; 
  
}

- (void)viewDidUnload {
  [super viewDidUnload];
  // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark - Actions

- (IBAction)done:(id)sender {
  [self.delegate flipsideViewControllerDidFinish:self];
}

- (IBAction)evilToggle:(id)sender {
  // changes the evilMode setting depending on value of the toggle
  if (self.evilSwitch.on) {
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"evilMode"];
    [[NSUserDefaults standardUserDefaults] synchronize];    
  }
  else {
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"evilMode"];
    [[NSUserDefaults standardUserDefaults] synchronize];
  }
}

- (IBAction)adjustWordLength:(id)sender {
  // changes the wordLength setting and updates UI label
  int wordLengthInt = (int) self.wordLength.value;
  [[NSUserDefaults standardUserDefaults] setInteger:wordLengthInt forKey:@"wordLength"];
  [[NSUserDefaults standardUserDefaults] synchronize];
  self.wordLengthLabel.text = [NSString stringWithFormat:@"%d letters", wordLengthInt]; 
}

- (IBAction)adjustMaxGuess:(id)sender {
  // changes the maxGuesses settting and updates UI label
  int maxGuessInt = (int) self.maxGuess.value;
  [[NSUserDefaults standardUserDefaults] setInteger:maxGuessInt forKey:@"maxGuesses"];
  [[NSUserDefaults standardUserDefaults] synchronize];
  self.maxGuessLabel.text = [NSString stringWithFormat:@"%d guesses", maxGuessInt];   
}


@end
