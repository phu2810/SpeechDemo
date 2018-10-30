//
//  DatabaseControl.m
//  sources
//
//  Created by Phu on 1/23/17.
//
//

#import "DatabaseControl.h"
#import "../filemanager/FileControl.h"
#import "Utils.h"
@interface DatabaseControl () {
    int dbVersion;
}
@end

@implementation DatabaseControl

static DatabaseControl *inst = nil;

+ (DatabaseControl*)instance {
    @synchronized(self) {
        if (inst == nil)
            inst = [[self alloc] init];
    }
    return inst;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (void) setUp {
    NSString *dirToSaveDB = [[FileControl instance] genDirForFileInDocumentDir:@"database.db"];
    if ([[FileControl instance] checkFileExist:dirToSaveDB]) {
    }
    else {
        [[FileControl instance] copyFileInMainBundle:@"database.db" toDir:dirToSaveDB];
    }
    [[DatabaseControl instance] initWithDBFilePath:dirToSaveDB];
    [[DatabaseControl instance] openDB];
    [self checkUpdateDB];
}

- (void) initWithDBFilePath:(NSString *)dbFile {
    _fmdb = [FMDatabase databaseWithPath:dbFile];
}

- (void) openDB {
    if (![_fmdb open]) {
        _fmdb = nil;
    }
    else {
    }
}

- (void) checkUpdateDB {
    FMResultSet *s = [_fmdb executeQuery: @"SELECT * FROM DB_INFO"];
    if ([s next]) {
        dbVersion = [s intForColumnIndex:1];
        if (dbVersion == 1) {
            BOOL isSuccess;
            isSuccess = [_fmdb executeUpdate:@"CREATE TABLE IF NOT EXISTS \"MESSAGES\" ( \"ID\" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE, \"local_id\" INTEGER NOT NULL UNIQUE, \"timestamp\" INTEGER, \"server_id\" TEXT, \"from_me\" INTEGER DEFAULT 0, \"data\" TEXT );"];
            isSuccess = [_fmdb executeUpdate:@"CREATE INDEX if not exists \"MESSAGES_INDEX\" on \"MESSAGES\" (\"local_id\");"];
            [_fmdb executeUpdate:@"UPDATE \"DB_INFO\" SET \"DB_VERSION\" = 2 WHERE \"ID\" = 1"];
            dbVersion = 2;
        }
        if (dbVersion == 2) {
            BOOL isSuccess;
            isSuccess = [_fmdb executeUpdate:@"ALTER TABLE MESSAGES ADD COLUMN rate_message INTEGER DEFAULT 0"];
            [_fmdb executeUpdate:@"UPDATE \"DB_INFO\" SET \"DB_VERSION\" = 3 WHERE \"ID\" = 1"];
            dbVersion = 3;
        }
        if (dbVersion == 3) {
            BOOL isSuccess;
            isSuccess = [_fmdb executeUpdate:@"ALTER TABLE MESSAGES ADD COLUMN send_expert INTEGER DEFAULT 0"];
            [_fmdb executeUpdate:@"UPDATE \"DB_INFO\" SET \"DB_VERSION\" = 4 WHERE \"ID\" = 1"];
            dbVersion = 4;
        }
    }
}
- (void) closeDB {
    if (_fmdb) {
        [_fmdb close];
        _fmdb = nil;
    }
}

- (void)dealloc
{
    [self closeDB];
}

@end
