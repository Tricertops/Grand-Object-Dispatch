//
//  GODSource.h
//  Grand Object Dispatch
//
//  Created by Martin Kiss on 10.7.13.
//  Copyright (c) 2013 Martin Kiss. All rights reserved.
//

#import "GODObject.h"



typedef enum GODSourceType : NSInteger {
    GODSourceTypeDataAdd,
    GODSourceTypeDataOr,
    
    GODSourceTypeMachSend,
    GODSourceTypeMachReceive,
    
    GODSourceTypeSignal,
    GODSourceTypeProcess,
    
    GODSourceTypeRead,
    GODSourceTypeVNode,
    GODSourceTypeWrite,
    
    GODSourceTypeTimer,
} GODSourceType;



@interface GODSource : GODObject


- (instancetype)initWithType:(GODSourceType)type handle:(uintptr_t)handle mask:(unsigned long)mask queue:(GODQueue *)queue;
- (GODSourceType)type;
- (uintptr_t)handle;
- (unsigned long)mask;
- (unsigned long)data;

- (void)cancel;
- (BOOL)isCancelled;

- (void)setRegistrationHandler:(GODBlock)block;
- (void)setCancellationHandler:(GODBlock)block;
- (void)setEventHandler:(GODBlock)block;

- (void)setTimerStart:(NSDate *)date interval:(NSTimeInterval)interval leeway:(NSTimeInterval)leeway;

- (instancetype)initWithDispatchSource:(dispatch_source_t)dispatchSource;
- (dispatch_source_t)dispatchSource;


@end




