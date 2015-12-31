//
//  AppDelegate.m
//  RandomImageUploadClient
//
//  Created by Le Thai Phuc Quang on 2/21/15.
//  Copyright (c) 2015 QuangLTP. All rights reserved.
//

#import "AppDelegate.h"
#import <ParseOSX/ParseOSX.h>

@interface AppDelegate ()

@end

@implementation AppDelegate

-(void)applicationWillFinishLaunching:(NSNotification *)notification {
    //NSLog(@"willfin");
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    //NSLog(@"bf setup");
    [self setupParse];
    //NSLog(@"at setup");
}

- (void)setupParse {
    //[Parse enableLocalDatastore];
    
    // Initialize Parse.
    [Parse setApplicationId:@"zHrCQLNtuBNRy2va57fGnxaVx2VbMD3oU0thUgi6"
                  clientKey:@"Wgw5cu7ljGgYZiYF2A8s2mzSXOEYndGxUr8SV5rE"];
    
    // [Optional] Track statistics around application opens.
    [PFAnalytics trackAppOpenedWithLaunchOptions:nil];
    
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

@end
