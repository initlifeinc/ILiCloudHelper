//
//  ILiCloudHelper.h
//  testicould
//
//  Created by guodi.ggd on 7/23/15.
//  Copyright (c) 2015 guodi.ggd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CloudKit/CloudKit.h>

#define ILiCloudErrorDomain @"ILiCloudErrorDomain"

@interface ILiCloudHelper : NSObject
// table name is use the default name
- (CKRecord *)newRecordWithID:(id)uniqueId;
- (CKRecord *)newRecordWithID:(id)uniqueId tableName:(NSString *)tableName;

- (void)saveRecord:(CKRecord *)record completionHandler:(void (^)(CKRecord *record, NSError *error))completeHander;

- (void)deleteRecord:(CKRecord *)record completionHandler:(void (^)(CKRecordID *recordID, NSError *error))completionHandler;

- (void)deleteRecordWithID:(id)uniqueId completionHandler:(void (^)(CKRecordID *recordID, NSError *error))completionHandler;

- (void)fetchRecordWithID:(id)uniqueId completionHandler:(void (^)(CKRecord *record, NSError *error))completionHandler;

// if table name is nil, it means use the default table name
- (void)performQueryOnTable:(NSString *)tableName predicate:(NSPredicate *)predicate completionHandler:(void (^)(NSArray /* CKRecord */ *results, NSError *error))completionHandler;
@end
