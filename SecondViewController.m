//
//  SecondViewController.m
//  testicould
//
//  Created by guodi.ggd on 7/22/15.
//  Copyright (c) 2015 guodi.ggd. All rights reserved.
//

#import "SecondViewController.h"
#import "ILiCloudHelper.h"
@interface SecondViewController ()
@property (nonatomic, strong) ILiCloudHelper *cloudHelper;
@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.cloudHelper = [[ILiCloudHelper alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)clickInsertButton:(id)sender {
    CKRecord *record = [self.cloudHelper newRecordWithID:@"1000"];
    record[@"place"] = @"浙江";
    [self.cloudHelper saveRecord:record completionHandler:^(CKRecord *record, NSError *error) {
        NSLog(@"%@ _ %@", record, error);
    }];
    
}

- (IBAction)clickFilterQueryButton:(id)sender {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"place = %@", @"浙江"];
    [self.cloudHelper performQueryOnTable:nil predicate:predicate completionHandler:^(NSArray *results, NSError *error) {
        NSLog(@"%@ %@", results, error);
    }];
}


- (IBAction)clickDeleteButton:(id)sender {
    [self.cloudHelper fetchRecordWithID:@"1000" completionHandler:^(CKRecord *record, NSError *error) {
        if (error) {
            NSLog(@"%@",error);
        } else {
            NSLog(@"%@", record);
            [self.cloudHelper deleteRecord:record completionHandler:^(CKRecordID *recordID, NSError *error) {
                NSLog(@"%@ %@", recordID, error);
            }];
        }
    }];
}

// add large file by asset
- (IBAction)clickModifyButton:(id)sender {
    [self.cloudHelper fetchRecordWithID:@"1000" completionHandler:^(CKRecord *record, NSError *error) {
        if (error) {
            NSLog(@"%@",error);
            return ;
        }
        NSURL *fileUrl = [[NSBundle mainBundle] URLForResource:@"2" withExtension:@"png"];
        CKAsset *asset = [[CKAsset alloc] initWithFileURL:fileUrl];
        record[@"db"] = asset;
        record[@"place"] = @"hehe";
        [self.cloudHelper saveRecord:record completionHandler:^(CKRecord *record, NSError *error) {
            if (error) {
                NSLog(@"modify: save error %@", error);
            } else {
                NSLog(@"modify: save success");
            }
        }];
    }];
}


- (IBAction)clickQueryButton:(id)sender {
    [self.cloudHelper fetchRecordWithID:@"1000" completionHandler:^(CKRecord *record, NSError *error) {
        NSLog(@"%@  error = %@", record, error);
    }];
}



@end
