//
//  GameplayDelegate.h
//  project2
//
//  Created by James Chou on 4/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GameplayDelegate <NSObject>
- (NSMutableArray*)playLetter:(NSString*)letter withArray:(NSMutableArray*)array;
@end
