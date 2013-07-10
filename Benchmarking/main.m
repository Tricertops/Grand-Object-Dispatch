//
//  main.m
//  Benchmarking
//
//  Created by Martin Kiss on 10.7.13.
//  Copyright (c) 2013 Martin Kiss. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GrandObjectDispatch.h"


void godb_linear(NSUInteger count);
void godb_parallel(NSUInteger count);
void godb_serial(NSUInteger count);
void godb_iteration(NSUInteger index);


int main(int argc, const char * argv[]) {
    @autoreleasepool {
        
        NSUInteger benchmarkCount = 1000;
        NSUInteger iterationCount = 10000;
        
        NSLog(@"Linear: %f s", [GODObject benchmark:benchmarkCount block:^{
            godb_linear(iterationCount);
        }]);
        
        NSLog(@"Parallel: %f s", [GODObject benchmark:benchmarkCount block:^{
            godb_parallel(iterationCount);
        }]);
        
        NSLog(@"Serial: %f s", [GODObject benchmark:benchmarkCount block:^{
            godb_serial(iterationCount);
        }]);
        
    }
    return 0;
}


void godb_linear(NSUInteger count) {
    for (NSUInteger index = 0; index < count; index++) {
        godb_iteration(index);
    }
}

void godb_parallel(NSUInteger count) {
    GODQueue *queue = [[GODQueue alloc] initWithName:@"com.MartinKiss.GrandObjectDispatch.benchmarkQueue.parallel" concurrent:YES];
    [queue apply:count block:^(NSUInteger index) {
        godb_iteration(index);
    }];
    [queue barrierSync:^{}];
}

void godb_serial(NSUInteger count) {
    GODQueue *queue = [[GODQueue alloc] initWithName:@"com.MartinKiss.GrandObjectDispatch.benchmarkQueue.serial" concurrent:NO];
    [queue apply:count block:^(NSUInteger index) {
        godb_iteration(index);
    }];
    [queue barrierSync:^{}];
}

void godb_iteration(NSUInteger index) {
    // I needed some expensinve operation...
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // ... but didn't want to use regexes.
}
