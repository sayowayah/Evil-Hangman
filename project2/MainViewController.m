//
//  MainViewController.m
//  project2
//
//  Created by James Chou on 3/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MainViewController.h"
#import "EvilGameplay.h"
// TODO: uncomment below once GoodGameplay model is complete
//#import "GoodGameplay.h"

@interface MainViewController ()

@end

@implementation MainViewController

@synthesize sortedWords = _sortedWords;
@synthesize activeWords = _activeWords;
@synthesize maxGuesses = _maxGuesses;
@synthesize remainingGuesses = _remainingGuesses;
@synthesize rightLetters = _rightLetters;
@synthesize label = _label;
@synthesize textField = _textField;
@synthesize button = _button;
@synthesize progress = _progress;
@synthesize letterList = _letterList;
@synthesize evil = _evil;
@synthesize evilInsert = _evilInsert;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
  {
    
    // load plist file into array
    NSMutableArray *words = [[NSMutableArray alloc] initWithContentsOfFile:
                             [[NSBundle mainBundle] pathForResource:@"words" ofType:@"plist"]];
    
    
    // create dictionary to store array of words with word length as key
    NSMutableDictionary *sortedWords = [[NSMutableDictionary alloc] init];
    self.sortedWords = sortedWords;
    NSUInteger maxWordLength = 0;
    
    for (NSString *word in words) {
      // create NSString object of word length to serve as keys
      NSUInteger wordLength = [word length];
      NSString *intString = [NSString stringWithFormat:@"%d", wordLength];

      // keep track of longest word to use in settings view
      if (wordLength > maxWordLength){
        maxWordLength = wordLength;
      }
      
      if ([sortedWords objectForKey:intString]){
        // add word to the array in the dictionary
        [[sortedWords objectForKey:intString] addObject:word];
      }
      else{
        // create new array with word and add key value pair to dictionary
        NSMutableArray *array = [[NSMutableArray alloc] initWithObjects:word, nil];
        [sortedWords setObject:array forKey:[NSString stringWithFormat:@"%d", [word length]]];
      }

      // Future TODO: add support for "holes" in the dataset, e.g. no words of length 9 exist. 
    // Proposal: create array of keys. Slider has max value of this array length. Slider value indexes into this array of keys.
    
      
    }
    
    // save the length of longest word to use in settings view
    [[NSUserDefaults standardUserDefaults] setInteger:maxWordLength forKey:@"maxWordLength"];
    
  }
return self;
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField{
  // enable GO button on keyboard to enter letter
  if (textField == self.textField){
    [self play:self];    
  }
  return YES;
}


- (void)viewDidLoad {
  [super viewDidLoad];
  [self startGame:self];
  
}

- (IBAction)startGame:(id)sender {
  // reset progress bar
  self.progress.progress = (float) 1.0;

  // set |maxGuesses| based on settings
  self.maxGuesses = [[NSUserDefaults standardUserDefaults] integerForKey:@"maxGuesses"];

  // reset |remainingGuesses| to max guesses
  self.remainingGuesses = self.maxGuesses;
  
  // reset |rightLetters| to zero
  self.rightLetters = 0;
  
  
  int wordLength = [[NSUserDefaults standardUserDefaults] integerForKey:@"wordLength"];
  
  // dynamically create blank slots based on |wordLength|
  NSMutableString *blanks= [[NSMutableString alloc] init ];
  for (int i=0; i<wordLength; i++){
    [blanks appendString:@"_ "];
  }
  self.label.text = blanks;
  
  // reset letter list to full alphabet
  self.letterList.text = @"A B C D E F G H I J K L M N O P Q R S T U V W X Y Z";

  if (![[NSUserDefaults standardUserDefaults] boolForKey:@"evilMode"]){
    [self.evil setHidden:YES];
    [self.evilInsert setHidden:YES];
  }
  else {
    [self.evil setHidden:NO];
    [self.evilInsert setHidden:NO];
  }

  // cast word length int into a NSString, which is the type of the keys in sortedWords dictionary
  NSString *wordLengthString = [NSString stringWithFormat:@"%d", wordLength];
  
  // extract array of words with the specified length and set as |activeWords|
  NSMutableArray *activeWords = [[NSMutableArray alloc] initWithArray:[self.sortedWords objectForKey:wordLengthString]];
  self.activeWords = activeWords;
  
}



- (IBAction)play:(id)sender {
  

  // get letter from user input
  NSString *letter = [self.textField.text lowercaseString];

  // error alert if more than one letter submitted
  if (letter.length > 1) {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Nope!" 
                                                    message:@"Can't enter more than one letter" 
                                                   delegate:self 
                                          cancelButtonTitle:@"Try again" 
                                          otherButtonTitles:nil];
    [alert setTag:1];
    [alert show];
    return;
  }
  // error alert if blank is submitted
  if (letter.length == 0) {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Umm..." 
                                                    message:@"Please enter a letter" 
                                                   delegate:self 
                                          cancelButtonTitle:@"Try again" 
                                          otherButtonTitles:nil];
    [alert setTag:1];
    [alert show];
    return;    
  }
  
  // error alert if non-alphabet character is submitted  

  // create set of alphabet letters
  NSCharacterSet *lowerCaseLetters = [NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyz"];
  if([letter rangeOfCharacterFromSet:lowerCaseLetters].location == NSNotFound) {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Nope!" 
                                                    message:@"Only enter letters please" 
                                                   delegate:self 
                                          cancelButtonTitle:@"Try again" 
                                          otherButtonTitles:nil];
    [alert setTag:1];
    [alert show];
    return;
  }

  // error alert if letter already entered
  if ([[letter uppercaseString] rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:self.letterList.text]].location == NSNotFound){
    NSString *message = [NSString stringWithFormat:@"You have already entered %@", letter];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Umm..." 
                                                    message:message
                                                   delegate:self 
                                          cancelButtonTitle:@"Try again" 
                                          otherButtonTitles:nil];
    [alert setTag:1];
    [alert show];
    return;     
  }

  
  // Replace chosen letter in the letter list with blank space
  NSString *updatedLetterList = [self.letterList.text stringByReplacingOccurrencesOfString:[self.textField.text uppercaseString] withString:@" "];
  self.letterList.text = updatedLetterList;  

  // TEMP: remove this once instantiation of good gameplay is implemented below
  EvilGameplay *game = [[EvilGameplay alloc] init];
  
  // instantiate a gameplay using good or evil
  if ([[NSUserDefaults standardUserDefaults] boolForKey:@"evilMode"]){
    // TEMP: uncomment when below is implemented   
    // EvilGameplay *game = [[EvilGameplay alloc] init];
  }
  else {
    // TODO: instantiate good gameplay 
    // GoodGameplay *game = [[GoodGameplay alloc] init];
  }
  
  // set |activeWords| as the new subset of words from the model method  
  NSMutableArray *tempArray = [[NSMutableArray alloc] initWithArray:[game playLetter:letter withArray:self.activeWords]];
  [self.activeWords removeAllObjects];
  [self.activeWords addObjectsFromArray:tempArray];
  
  // check if new array of words contains the letter
  if ([[[self.activeWords objectAtIndex:0] lowercaseString] rangeOfString:letter].location!=NSNotFound){
    
    // update the blanks to reflect the new word
    // take the first activeword
    NSString *word = [[self.activeWords objectAtIndex:0] lowercaseString];
    int wordLength = word.length;
    
    // iterate through word
    for (int j=0; j<wordLength; j++) {
      
      char letterToCheck = [word characterAtIndex:j];
      char letterChar = [letter characterAtIndex:0];
      
      if (letterToCheck == letterChar) {
        
        // to account for spaces, multiply by 2.  But also check if its in the first position (since you can't multiply by zero)
        NSRange range = NSMakeRange(j * 2,1);
        if (j == 0) {
          range = NSMakeRange(j,1);	
          // capitalize first letter
          self.label.text = [self.label.text stringByReplacingCharactersInRange:range withString:[letter uppercaseString]];
        }        
        else {
          self.label.text = [self.label.text stringByReplacingCharactersInRange:range withString:letter];
        }
        
        // add count to |rightLetters|
        self.rightLetters++;
      }
    }
    // show congrats alert if |rightLetters| equals length of word
    if (self.rightLetters == wordLength){
      UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Congrats!!" 
                                                      message:@"You win!"
                                                     delegate:self 
                                            cancelButtonTitle:@"Restart" 
                                            otherButtonTitles:nil];
      [alert setTag:2];
      [alert show];      
    }
  }
  else {
    
    // calculate the % remaining
    float progressDecimal = (float) (self.remainingGuesses - 1) / (float) self.maxGuesses;
    
    // update the progress indicator  
    self.progress.progress = progressDecimal;
    
    // update remaining guesses  
    self.remainingGuesses--;
    
    // if remaining guess = 0, show finish screen
    if (self.remainingGuesses == 0){
      NSString *word = [NSString stringWithFormat:@"The word was %@", [self.activeWords objectAtIndex:0]];
      //      NSString *word = [self.activeWords objectAtIndex:0];
      UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"You lose!" 
                                                      message:word
                                                     delegate:self 
                                            cancelButtonTitle:@"Restart" 
                                            otherButtonTitles:nil];
      [alert setTag:2];
      [alert show];
    }
  }
  
  // clear out the textfield
  self.textField.text = @"";
  
  // hide keyboard
  [self.textField resignFirstResponder];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
  // restart game if end game screen (win or lose)
  if (alertView.tag == 2) {
    [self startGame:self];    
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
