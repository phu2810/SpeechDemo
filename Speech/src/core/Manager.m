//
//  Manager.m
//  sources
//
//  Created by Phu on 1/25/17.
//
//

#import "Manager.h"
#import "HTTPNetworkControl.h"

@import Firebase;

//
@interface Manager () {
}
@end

@implementation Manager

static Manager *inst = nil;

+ (Manager*)instance {
    @synchronized(self) {
        if (inst == nil)
            inst = [[self alloc] init];
    }
    return inst;
}

- (instancetype)init {
    self = [super init];
    if (self) {
    }
    return self;
}
@end
