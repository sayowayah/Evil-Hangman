//
//  EvilGameplay.m
//  project2
//
//  Created by James Chou on 4/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EvilGameplay.h"

@implementation EvilGameplay

- (NSMutableArray*)playLetter:(NSString *)letter withArray:(NSMutableArray *)array {
  
  NSMutableDictionary *equivalenceClasses = [[NSMutableDictionary alloc] init];
  
  // TODO: figure out how to access activeWords from the MainViewController
  
  NSMutableArray *wordArray = [[NSMutableArray alloc] initWithArray:array];
  
  // iterate through each word in the |activeWords| array
  for (NSString *word in wordArray){
    
    
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

  // TODO: update UI   
  
  
  // return largest equivalence class
  return [equivalenceClasses objectForKey:keyOfLargestClass];  
  
}


@end
