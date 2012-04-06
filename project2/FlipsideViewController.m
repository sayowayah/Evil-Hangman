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
	// Do any additional setup after loading the view, typically from a nib.
  self.evilSwitch.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"evilMode"];
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
  int wordLengthInt = (int) self.wordLength.value;
  [[NSUserDefaults standardUserDefaults] setInteger:wordLengthInt forKey:@"wordLength"];
  [[NSUserDefaults standardUserDefaults] synchronize];
  self.wordLengthLabel.text = [NSString stringWithFormat:@"%d letters", wordLengthInt]; 
}


@end
