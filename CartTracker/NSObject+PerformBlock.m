//
//  NSObject+PerformBlock.m
//  Cassino
//
//  Created by Michael Dokken on 6/25/12.
//  Copyright (c) 2012 Michael Dokken. All rights reserved.
//

#import "NSObject+PerformBlock.h"

@implementation NSObject (PerformBlock)

- (void)performBlock:(void(^)(void))block{
    if (block) block();
}

- (void)performBlockOnMainThread:(void(^)(void))block{
    [self performSelectorOnMainThread:@selector(performBlock:) withObject:[block copy] waitUntilDone:NO];
}

- (void)performBlockInBackground:(void(^)(void))block{
    [self performSelectorInBackground:@selector(performBlock:) withObject:[block copy]];
}

- (void)performBlock:(void(^)(void))block afterDelay:(NSTimeInterval)delay{
    [self performSelector:@selector(performBlock:) withObject:[block copy] afterDelay:delay];
}

@end
