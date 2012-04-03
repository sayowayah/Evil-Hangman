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

@synthesize sortedWords = _sortedWords;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
  {
    
    // load plist file into array
    NSMutableArray *words = [[NSMutableArray alloc] initWithContentsOfFile:
                             [[NSBundle mainBundle] pathForResource:@"small" ofType:@"plist"]];
    
    // create dictionary to store array of words with word length as key
    NSMutableDictionary *sortedWords = [[NSMutableDictionary alloc] init];
    self.sortedWords = sortedWords;
    
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
  return self;
}


- (void)viewDidLoad {
  [super viewDidLoad];
  
  
  
}

- (void)play:(NSString*)letter {
  // TODO: get word length from the settings
  int wordLength = 4;
  // cast word length int into a NSString, which is the type of the keys in sortedWords dictionary
  NSString *wordLengthString = [NSString stringWithFormat:@"%d", wordLength];
  
  NSMutableDictionary *equivalenceClasses = [[NSMutableDictionary alloc] init];
  
  // iterate through each word of length |wordLength|
  for (NSString *word in [self.sortedWords objectForKey:wordLengthString]){

    // calculate |classValue| of word by iterating through string length
    int classValue = 0;
    for (int charIndex=0; charIndex < word.length; charIndex++){
      if([[letter lowercaseString] isEqualToString:[[word substringWithRange: NSMakeRange(charIndex,1)] lowercaseString]]){
        classValue += (int)pow(2.0,(double)charIndex);
      }
    }
    
    // insert word into equivalence class with |classValue|, cast as a string, as the key
    NSString *classValueString = [NSString stringWithFormat:@"%d", classValue];    
    if ([equivalenceClasses objectForKey:classValueString]){
      // add word to the array in the dictionary
      [[equivalenceClasses objectForKey:classValueString] addObject:word];
    }
    else{
      // create new array with word and add key value pair to dictionary
      NSMutableArray *array = [[NSMutableArray alloc] initWithObjects:word, nil];
      [equivalenceClasses setObject:array forKey:[NSString stringWithFormat:@"%d", classValueString]];
    }
  }
}


- (void)viewDidUnload {
  [super viewDidUnload];
  // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark - Flipside View

- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller {
  [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)showInfo:(id)sender {    
  FlipsideViewController *controller = [[FlipsideViewController alloc] initWithNibName:@"FlipsideViewController" bundle:nil];
  controller.delegate = self;
  controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
  [self presentModalViewController:controller animated:YES];
}

@end
