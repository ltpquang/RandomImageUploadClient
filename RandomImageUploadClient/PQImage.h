//
//  PQImage.h
//  RandomImageUploadClient
//
//  Created by Le Thai Phuc Quang on 2/21/15.
//  Copyright (c) 2015 QuangLTP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PQImageCategoryEnum.h"

@class PFObject;


@interface PQImage : NSObject
@property NSString *fileName;
@property NSURL *fileURL;
@property NSString *category;
@property BOOL isUploaded;

- (id)initWithURL:(NSURL *)url;
- (void)uploadImageAndSuccess:(void(^)(PFObject *uploadObject))successCallback
                   andFailure:(void(^)(NSError *error))failureCallback;
@end
