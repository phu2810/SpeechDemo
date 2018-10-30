//
//  GVUserDefaults+Properties.h
//  GVUserDefaults
//
//  Created by Kevin Renskers on 18-12-12.
//  Copyright (c) 2012 Gangverk. All rights reserved.
//

#import "GVUserDefaults.h"

@interface GVUserDefaults (Properties)

@property (nonatomic, weak) NSString *versionDB;
@property (nonatomic, weak) NSString *host;
@property (nonatomic, weak) NSString *port;
@property (nonatomic, weak) NSString *recordAllTime;
@property (nonatomic, weak) NSString *sampleRate;
@property (nonatomic, weak) NSString *saveHistory;
@end
