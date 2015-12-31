//
//  PQBooleanValueTransformer.m
//  RandomImageUploadClient
//
//  Created by Le Thai Phuc Quang on 2/21/15.
//  Copyright (c) 2015 QuangLTP. All rights reserved.
//

#import "PQBooleanValueTransformer.h"

@implementation PQBooleanValueTransformer

+ (Class)transformedValueClass {
    return [NSString class];
}

- (id)transformedValue:(id)value {
    if ([value boolValue]) {
        return @"Yes";
    }
    else {
        return @"No";
    }
}

+ (BOOL)allowsReverseTransformation {
    return YES;
}

- (id)reverseTransformedValue:(id)value {
    NSString *string = (NSString *)value;
    if ([[string lowercaseString] isEqualToString:@"yes"]) {
        return @YES;
    }
    return @NO;
}

@end
