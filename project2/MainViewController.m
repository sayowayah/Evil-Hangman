//
//  MainViewController.m
//  project2
//
//  Created by James Chou on 3/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController


- (void)viewDidLoad
{
  [super viewDidLoad];
  
  // load plist file into array
  NSMutableArray *words = [[NSMutableArray alloc] initWithContentsOfFile:
                                [[NSBundle mainBundle] pathForResource:@"small" ofType:@"plist"]];

  // create dictionary to store array of words with word length as key
  NSMutableDictionary *sortedWords = [[NSMutableDictionary alloc] init];
  
  for (NSString *word in words) {
    // create NSString object of word length to serve as keys
    NSString *intString = [NSString stringWithFormat:@"%d", [word length]];
    if ([sortedWords objectForKey:intString]){
      // add word to the array in the dictionary
      [[sortedWords objectForKey:intString] addObject:word];
    }
    else{
      // create new array with word and add key value pair to dictionary
      NSMutableArray *array = [[NSMutableArray alloc] initWithObjects:word, nil];
      [sortedWords setObject:array forKey:[NSString stringWithFormat:@"%d", [word length]]];
    }
  // TODO: cut down words of set length, chosen in the settings    
  }
  
}

- (void)viewDidUnload
{
  [super viewDidUnload];
  // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark - Flipside View

- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller
{
  [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)showInfo:(id)sender
{    
  FlipsideViewController *controller = [[FlipsideViewController alloc] initWithNibName:@"FlipsideViewController" bundle:nil];
  controller.delegate = self;
  controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
  [self presentModalViewController:controller animated:YES];
}

@end
