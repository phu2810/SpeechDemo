//
//  DatabaseControl.h
//  sources
//
//  Created by Phu on 1/23/17.
//
//

#import <Foundation/Foundation.h>
#import "FMDB.h"

@interface DatabaseControl : NSObject

+ (DatabaseControl*)instance;

@property (nonatomic, strong) FMDatabase *fmdb;

- (void) setUp;

- (void) openDB;

- (void) closeDB;

@end
