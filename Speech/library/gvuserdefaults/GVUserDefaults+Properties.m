//
//  GVUserDefaults+Properties.m
//  GVUserDefaults
//
//  Created by Kevin Renskers on 18-12-12.
//  Copyright (c) 2012 Gangverk. All rights reserved.
//

#import "GVUserDefaults+Properties.h"
#import "Utils.h"
#import "Constants.h"

@implementation GVUserDefaults (Properties)

@dynamic versionDB;
@dynamic host;
@dynamic port;
@dynamic recordAllTime;
@dynamic sampleRate;

- (NSDictionary *)setupDefaults {
    return @{
             @"versionDB": @"1",
             @"host": HOST,
             @"port": PORT,
             @"recordAllTime": @"",
             @"sampleRate": SAMPLE_RATE,
             @"saveHistory": @"1",
    };
}

@end
