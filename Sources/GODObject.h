//
//  GODObject.h
//  Grand Object Dispatch
//
//  Created by Martin Kiss on 8.7.13.
//  Copyright (c) 2013 Martin Kiss. All rights reserved.
//

#import <Foundation/Foundation.h>



typedef dispatch_block_t GODBlock;





@class GODQueue;

/// Object wrapper around dispatch_object_t. This is abstract class, you can instantinate of of subclasses: GODQueue.
@interface GODObject : NSObject





@end
