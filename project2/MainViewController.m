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
@synthesize activeWords = _activeWords;

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
    }

    
    // testing!!!
    
    int wordLength = 4;
    // cast word length int into a NSString, which is the type of the keys in sortedWords dictionary
    NSString *wordLengthString = [NSString stringWithFormat:@"%d", wordLength];
    
    // extract array of words with the specified length and set as |activeWords|
    NSMutableArray *activeWords = [[NSMutableArray alloc] initWithArray:[self.sortedWords objectForKey:wordLengthString]];
    self.activeWords = activeWords;
    
    
    NSString *letter = @"e";
    
    NSMutableDictionary *equivalenceClasses = [[NSMutableDictionary alloc] init];
    
    // iterate through each word in the |activeWords| array
    for (NSString *word in self.activeWords){
      
      
      // |classValue| is a "binary" number based on if the inputted letter exists at each character index in word
      NSInteger classValue = 0;
      // calculate |classValue| of word by iterating through string length
      for (int charIndex=0; charIndex < word.length; charIndex++){
        if([[letter lowercaseString] isEqualToString:[[word substringWithRange: NSMakeRange(charIndex,1)] lowercaseString]]){
          classValue += (NSInteger)pow(2.0,(double)charIndex);
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
        [equivalenceClasses setObject:array forKey:classValueString];
      }
    }
    
    
    // choose the largest equivalence class
    NSInteger maxSize = 0;
    NSString *keyOfLargestClass;
    for (id key in equivalenceClasses) {
      if ((NSInteger) [[equivalenceClasses objectForKey:key] count] > maxSize){
        maxSize = [[equivalenceClasses objectForKey:key] count];   
        keyOfLargestClass = key;
      }
      // break ties with random number generators
      else if((NSInteger)[[equivalenceClasses objectForKey:key] count] == maxSize) {
        int random1 = arc4random();
        int random2 = arc4random();
        if (random1 > random2){
          maxSize = [[equivalenceClasses objectForKey:key] count];   
          keyOfLargestClass = key;
        }
      }
    }
    
    // set largest equivalence class as |activeWords|
    self.activeWords = [equivalenceClasses objectForKey:keyOfLargestClass];  
    
    // update UI   
    
    
    
    
    
    
    
    
    
  }
  return self;
}


- (void)viewDidLoad {
  [super viewDidLoad];
  
}

- (void)startGame {
  // TODO: get word length from the settings
  int wordLength = 4;
  // cast word length int into a NSString, which is the type of the keys in sortedWords dictionary
  NSString *wordLengthString = [NSString stringWithFormat:@"%d", wordLength];
  
  // extract array of words with the specified length and set as |activeWords|
  NSMutableArray *activeWords = [[NSMutableArray alloc] initWithArray:[self.sortedWords objectForKey:wordLengthString]];
  self.activeWords = activeWords;

}




- (void)playLetter:(NSString *)letter{
  
  NSMutableDictionary *equivalenceClasses = [[NSMutableDictionary alloc] init];
  
  // iterate through each word in the |activeWords| array
  for (NSString *word in self.activeWords){
    
    
    // |classValue| is a "binary" number based on if the inputted letter exists at each character index in word
    int classValue = 0;
    // do quick check if letter even exists in the word
    if ([word rangeOfString:letter].location == NSNotFound) {
      classValue = 0;
    }
    else {
      // calculate |classValue| of word by iterating through string length
      for (int charIndex=0; charIndex < word.length; charIndex++){
        if([[letter lowercaseString] isEqualToString:[[word substringWithRange: NSMakeRange(charIndex,1)] lowercaseString]]){
          classValue += (int)pow(2.0,(double)charIndex);
        }
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
  
  
  // choose the largest equivalence class
  NSInteger maxSize = 0;
  NSString *keyOfLargestClass;
  for (id key in equivalenceClasses) {
    if ((NSInteger) [[equivalenceClasses objectForKey:key] count] > maxSize){
      maxSize = [[equivalenceClasses objectForKey:key] count];   
      keyOfLargestClass = key;
    }
    // break ties with random number generators
    else if((NSInteger)[[equivalenceClasses objectForKey:key] count] == maxSize) {
      int random1 = arc4random();
      int random2 = arc4random();
      if (random1 > random2){
        maxSize = [[equivalenceClasses objectForKey:key] count];   
        keyOfLargestClass = key;
      }
    }
  }

  // set largest equivalence class as |activeWords|
  self.activeWords = [equivalenceClasses objectForKey:keyOfLargestClass];  
  
  // update UI
  
  
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
