//
//  MainViewController.m
//  project2
//
//  Created by James Chou on 3/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MainViewController.h"
#import "EvilGameplay.h"

@interface MainViewController ()

@end

@implementation MainViewController

@synthesize sortedWords = _sortedWords;
@synthesize activeWords = _activeWords;
@synthesize maxGuesses = _maxGuesses;
@synthesize remainingGuesses = _remainingGuesses;
@synthesize label = _label;
@synthesize textField = _textField;
@synthesize button = _button;
@synthesize progress = _progress;

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
    
    
  }
  return self;
}


- (void)viewDidLoad {
  [super viewDidLoad];
  [self startGame:self];
  
}

- (IBAction)startGame:(id)sender {
  self.progress.progress = (float) 1.0;
  self.maxGuesses = [[NSUserDefaults standardUserDefaults] integerForKey:@"maxGuesses"];
  self.remainingGuesses = self.maxGuesses;
  
  
  int wordLength = [[NSUserDefaults standardUserDefaults] integerForKey:@"wordLength"];
  
  // TODO: dynamically create slots based on |wordLength|
  self.label.text = @"_ _ _ _";
  
  // cast word length int into a NSString, which is the type of the keys in sortedWords dictionary
  NSString *wordLengthString = [NSString stringWithFormat:@"%d", wordLength];
  
  // extract array of words with the specified length and set as |activeWords|
  NSMutableArray *activeWords = [[NSMutableArray alloc] initWithArray:[self.sortedWords objectForKey:wordLengthString]];
  self.activeWords = activeWords;
  
}



- (IBAction)play:(id)sender {
  
  
  // get letter from user input
  NSString *letter = [self.textField.text lowercaseString];
  
  NSLog(@"letter entered: %@",letter);
  
  // instantiate a game using the evil gameplay
  EvilGameplay *game = [[EvilGameplay alloc] init];
  NSMutableArray *tempArray = [[NSMutableArray alloc] initWithArray:[game playLetter:letter withArray:self.activeWords]];
  // set |activeWords| as the new subset of words from the model method
  [self.activeWords removeAllObjects];
  [self.activeWords addObjectsFromArray:tempArray];
  
  // check if new array of words contains the letter
  if ([[[self.activeWords objectAtIndex:0] lowercaseString] rangeOfString:letter].location!=NSNotFound){
    // update the blanks to reflect the new word
    
    // take the first activeword
    NSString *word = [[self.activeWords objectAtIndex:0] lowercaseString];
    
    // iterate through word
    for (int j=0; j<word.length; j++) {
      
      NSLog(@"blank");
      
      char letterToCheck = [word characterAtIndex:j];
      char letterChar = [letter characterAtIndex:0];
      
      if (letterToCheck == letterChar) {
        
        // to account for spaces, multiply by 2.  But also check if its in the first position (since you can't multiply by zero)
        NSRange range = NSMakeRange(j * 2,1);
        
        // TODO: replace letter with a blank space
        if (j == 0) {
          range = NSMakeRange(j,1);	
        }
        self.label.text = [self.label.text stringByReplacingCharactersInRange:range withString:letter];
      }
    }
  }
  else {
    
    // calculate the % remaining
    float progressDecimal = (float) (self.remainingGuesses - 1) / (float) self.maxGuesses;
    
    // update the progress indicator  
    self.progress.progress = progressDecimal;
    
    // update remaining guesses  
    self.remainingGuesses--;
  }
  
  // clear out the textfield
  self.textField.text = @"";
  
  // hide keyboard
  [self.textField resignFirstResponder];
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
