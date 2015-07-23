//
//  ILiCloudHelper.m
//  testicould
//
//  Created by guodi.ggd on 7/23/15.
//  Copyright (c) 2015 guodi.ggd. All rights reserved.
//

#import "ILiCloudHelper.h"

#define ILDefaultCloudTypeName       @"ILDefaultType"

@interface ILiCloudHelper()
@property (nonatomic, readonly) CKDatabase *defaultDatabase;
@end


@implementation ILiCloudHelper

- (CKRecord *)newRecordWithID:(id)uniqueId
{
    return [self newRecordWithID:uniqueId tableName:nil];
}
- (CKRecord *)newRecordWithID:(id)uniqueId tableName:(NSString *)tableName
{
    if (!uniqueId) {
        return nil;
    }
    
    tableName = [self finalTableName:tableName];
    CKRecordID *recordID = [self adapterRecordID:uniqueId];
    if (!recordID) {
        return nil;
    }
    CKRecord *record = [[CKRecord alloc] initWithRecordType:tableName recordID:recordID];
    return record;
}

- (NSString *)finalTableName:(NSString *)tableName
{
    tableName = tableName.length > 0 ? tableName : ILDefaultCloudTypeName;
    return tableName;
}

- (CKDatabase *)defaultDatabase
{
    CKContainer *container = [CKContainer defaultContainer];
    CKDatabase *publicDatabase = [container publicCloudDatabase];
    return publicDatabase;
}

- (void)saveRecord:(CKRecord *)record completionHandler:(void (^)(CKRecord *record, NSError *error))completeHander
{
    if (!record) {
        if (completeHander) {
            completeHander(nil, [NSError errorWithDomain:ILiCloudErrorDomain code:100 userInfo:@{@"msg":@"record cannot be nil"}]);
        }
        return;
    }
    [self.defaultDatabase saveRecord:record completionHandler:completeHander];
}

- (void)deleteRecord:(CKRecord *)record completionHandler:(void (^)(CKRecordID *recordID, NSError *error))completionHandler
{
    [self deleteRecordWithID:record.recordID completionHandler:completionHandler];
}

- (void)deleteRecordWithID:(id)uniqueId completionHandler:(void (^)(CKRecordID *recordID, NSError *error))completionHandler
{
    CKRecordID *recordID = [self adapterRecordID:uniqueId];
    NSAssert(recordID, @"recordId show not be nil, uniqueID is iligel");
    [self.defaultDatabase deleteRecordWithID:recordID completionHandler:completionHandler];
}

- (CKRecordID *)adapterRecordID:(id)uniqueId
{
    CKRecordID *recordID = nil;

    if ([uniqueId isKindOfClass:[NSString class]]) {
        recordID = [[CKRecordID alloc] initWithRecordName:uniqueId];
    } else if ([uniqueId isKindOfClass:[CKRecordID class]]) {
        recordID = uniqueId;
    }
    return recordID;
}


- (void)fetchRecordWithID:(id)uniqueId completionHandler:(void (^)(CKRecord *record, NSError *error))completionHandler
{
    CKRecordID *recordID = [self adapterRecordID:uniqueId];
    NSAssert(recordID, @"recordId show not be nil, uniqueID is iligel");
    [self.defaultDatabase fetchRecordWithID:recordID completionHandler:completionHandler];
}


- (void)performQueryOnTable:(NSString *)tableName predicate:(NSPredicate *)predicate completionHandler:(void (^)(NSArray /* CKRecord */ *results, NSError *error))completionHandler
{
    CKQuery *query = nil;
    @try {
        tableName = [self finalTableName:tableName];
        query = [[CKQuery alloc] initWithRecordType:tableName predicate:predicate];
    }
    @catch (NSException *exception) {
        query = nil;
    }
    @finally {
        
    }

    if (!query) {
        return ;
    }
    [self.defaultDatabase performQuery:query inZoneWithID:nil completionHandler:completionHandler];
}
@end
