//
//  NSObject+PerformBlock.h
//  Cassino
//
//  Created by Michael Dokken on 6/25/12.
//  Copyright (c) 2012 Michael Dokken. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (PerformBlock)

- (void)performBlock:(void(^)(void))block;
- (void)performBlockOnMainThread:(void(^)(void))block;
- (void)performBlockInBackground:(void(^)(void))block;
- (void)performBlock:(void(^)(void))block afterDelay:(NSTimeInterval)delay;

@end
