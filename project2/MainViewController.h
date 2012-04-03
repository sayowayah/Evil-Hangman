//
//  MainViewController.h
//  project2
//
//  Created by James Chou on 3/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FlipsideViewController.h"

@interface MainViewController : UIViewController <FlipsideViewControllerDelegate>

@property (nonatomic, strong) NSMutableDictionary *sortedWords;

- (IBAction)showInfo:(id)sender;
- (void)play:(NSString*)letter;

@end
