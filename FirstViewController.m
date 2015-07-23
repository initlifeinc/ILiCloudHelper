//
//  FirstViewController.m
//  testicould
//
//  Created by guodi.ggd on 7/22/15.
//  Copyright (c) 2015 guodi.ggd. All rights reserved.
//

#import "FirstViewController.h"
#import <CloudKit/CloudKit.h>

@interface FirstViewController ()

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)clickFilterQueryButton:(id)sender {
    CKContainer *myContainer = [CKContainer defaultContainer];
    CKDatabase *publicDatabase = [myContainer publicCloudDatabase];
    NSPredicate *predicate = [NSPredicate
                              predicateWithFormat:@"userId = '123'"];
    CKQuery *ckQuery = [[CKQuery alloc] initWithRecordType:@"db" predicate:predicate];
    NSLog(@"begin query");

    [publicDatabase performQuery:ckQuery inZoneWithID:nil completionHandler:^(NSArray *results, NSError *error) {
        if (error) {
            NSLog(@"%@", error);
        } else {
            NSLog(@"perform query results: %@", results);
        }
    }];
}


- (IBAction)clickDeleteButton:(id)sender {
    CKContainer *myContainer = [CKContainer defaultContainer];
    CKDatabase *publicDatabase = [myContainer publicCloudDatabase];
    CKRecordID *storeRecordID = [[CKRecordID alloc] initWithRecordName:@"test"];
    [publicDatabase deleteRecordWithID:storeRecordID completionHandler:^(CKRecordID *recordID, NSError *error) {
        if (error) {
            NSLog(@"delete success");
        } else {
            NSLog(@"delete error = %@", error);
        }
    }];
}

// add large file by asset
- (IBAction)clickModifyButton:(id)sender {
    CKContainer *myContainer = [CKContainer defaultContainer];
    CKDatabase *publicDatabase = [myContainer publicCloudDatabase];
    CKRecordID *storeRecordID = [[CKRecordID alloc] initWithRecordName:@"test"];
    NSLog(@"begin modify");
    
    [publicDatabase fetchRecordWithID:storeRecordID completionHandler:^(CKRecord *record, NSError *error) {
        if (error) {
            NSLog(@"query error = %@", error);
        }
        else {
            NSLog(@"query success %@", record);

            record[@"userId"] = @"1234";
            record[@"userName"] = @"123";

            NSURL *fileUrl = [[NSBundle mainBundle] URLForResource:@"2" withExtension:@"png"];
            CKAsset *asset = [[CKAsset alloc] initWithFileURL:fileUrl];
            record[@"db"] = asset;
            
            [publicDatabase saveRecord:record completionHandler:^(CKRecord *record, NSError *error) {
                if (error) {
                    NSLog(@"modify: save error %@", error);
                } else {
                    NSLog(@"modify: save success");
                }
            }];
        }
    }];
}


- (IBAction)clickQueryButton:(id)sender {
    CKContainer *myContainer = [CKContainer defaultContainer];
    CKDatabase *publicDatabase = [myContainer publicCloudDatabase];
    CKRecordID *storeRecordID = [[CKRecordID alloc] initWithRecordName:@"test"];
    NSLog(@"begin query");
    
    [publicDatabase fetchRecordWithID:storeRecordID completionHandler:^(CKRecord *record, NSError *error) {
        if (error) {
            NSLog(@"query error = %@", error);
        }
        else {
            NSLog(@"query result = %@", record);

        }
    }];
}


- (IBAction)clickInsertButton:(id)sender {
    CKRecordID *storeRecordID = [[CKRecordID alloc] initWithRecordName:@"test"];
    CKRecord *storeRecord = [[CKRecord alloc] initWithRecordType:@"db" recordID:storeRecordID];
    storeRecord[@"userId"] = @"1234";
    
    CKContainer *myContainer = [CKContainer defaultContainer];
    CKDatabase *publicDatabase = [myContainer publicCloudDatabase];
    NSLog(@"modify: begin save");
    [publicDatabase saveRecord:storeRecord completionHandler:^(CKRecord *record, NSError *error) {
        if (error) {
            NSLog(@"save error %@", error);
        } else {
            NSLog(@"save success");
        }
    }];
    
}
@end
