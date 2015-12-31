//
//  PQImage.m
//  RandomImageUploadClient
//
//  Created by Le Thai Phuc Quang on 2/21/15.
//  Copyright (c) 2015 QuangLTP. All rights reserved.
//

#import "PQImage.h"
#import <ParseOSX/ParseOSX.h>

@implementation PQImage

- (id)initWithURL:(NSURL *)url {
    if (self = [super init]) {
        _fileName = [[url absoluteString] lastPathComponent];
        _fileURL = url;
        _category = [[[[url absoluteString]
                     lastPathComponent]
                     stringByDeletingPathExtension]
                     stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
        _isUploaded = NO;
    }
    return self;
}

- (id)init {
    if (self = [super init]) {
        _fileName = @"Not a file name";
        _fileURL = [NSURL URLWithString:@""];
        _category = @"none";
        _isUploaded = NO;
    }
    return self;
}

- (void)uploadImageAndSuccess:(void(^)(PFObject *uploadObject))successCallback
                   andFailure:(void(^)(NSError *error))failureCallback {
    NSData *imgData = [NSData dataWithContentsOfURL:_fileURL];
    PFFile *pFile = [PFFile fileWithName:_fileName data:imgData];
    NSLog(@"%@ - Start uploading file", _fileName);
    [pFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"%@ - Complete uploading file", _fileName);
            PFObject *imageObject = [PFObject objectWithClassName:@"PQImage"];
            imageObject[@"imageName"] = [_fileName stringByDeletingPathExtension];
            imageObject[@"imageFile"] = pFile;
            NSLog(@"%@ - Start creating object for file", _fileName);
            [imageObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    NSLog(@"%@ - Complete creating object for file", _fileName);
                    successCallback(imageObject);
                }
                else {
                    NSLog(@"%@ - Failed creating object for file", _fileName);
                    failureCallback(error);
                }
            }];
        }
        else {
            NSLog(@"%@ - Failed uploading file", _fileName);
            failureCallback(error);
        }
    }];
}
@end
