//
//  ViewController.m
//  RandomImageUploadClient
//
//  Created by Le Thai Phuc Quang on 2/21/15.
//  Copyright (c) 2015 QuangLTP. All rights reserved.
//

#import "ViewController.h"
#import <ParseOSX/ParseOSX.h>
#import "PQImage.h"


@interface ViewController()

@property (nonatomic) NSMutableArray *images;
@property (weak) IBOutlet NSTableView *tableView;
@property (strong) IBOutlet NSArrayController *arrayController;

@property (nonatomic) int count;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _images = [[NSMutableArray alloc] init];
    // Do any additional setup after loading the view.
    
    
}

- (void)viewDidAppear {
    //NSLog(@"vdl");
}

- (void)addInitImageCategory {
    NSDictionary *category = @{
                                //@"votay":@"Vỗ tay",
                                //@"hong":@"Hóng",
                                //@"fuck":@"Fuck",
                                //@"len":@"Lên",
                                //@"oi":@"Ói"
                               //@"facepalm":@"Facepalm",
                               //@"dongcam":@"Đồng cảm",
                               //@"eo":@"Éo"
                               //@"hucau":@"Hư cấu",
                               //@"khoc":@"Khóc",
                               //@"ngu":@"Ngu"
                               @"vai":@"Vãi"
                                };
    
    for (NSString *key in [category allKeys]) {
        PFObject *imgCat = [PFObject objectWithClassName:@"PQImageCategory"];
        imgCat[@"name"] = [category objectForKey:key];
        imgCat[@"tag"] = key;
        [imgCat saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                NSLog(@"%@ - %@", key, [category objectForKey:key]);
            }
        }];
    }
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

- (IBAction)loadButtonClicked:(id)sender {
    
    //NSMutableArray *images = _images;
    NSOpenPanel *panel = [[NSOpenPanel alloc] init];
    [panel setCanChooseDirectories:NO];
    [panel setCanChooseFiles:YES];
    [panel setAllowsMultipleSelection:YES];
    [panel setAllowedFileTypes:[NSImage imageTypes]];
    
    [panel beginWithCompletionHandler:^(NSInteger result) {
        if (result == NSFileHandlingPanelOKButton) {
            NSArray *urls = [panel URLs];
            for (NSURL *url in urls) {
                
                [_arrayController addObject:[[PQImage alloc] initWithURL:url]];
            }
            //_images = images;
            [self didChangeValueForKey:@"images"];
        }
        
    }];
    
}

- (IBAction)uploadButtonClicked:(id)sender {
    //Load all possible category
    [self getAllImageCategoryAsPFObject];
    //Foreach category, filter the image array by category, upload them
    //[self addInitImageCategory];
}

- (void)getAllImageCategoryAsPFObject {
    PFQuery *query = [PFQuery queryWithClassName:@"PQImageCategory"];
    
    NSLog(@"Start fetching image categories");
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            NSLog(@"Successfully retrieved %lu scores.", (unsigned long)objects.count);
            // Do something with the found objects
            for (PFObject *object in objects) {
                _count = 0;
                [self filterImageListAndUploadAndAddToImageCategory:object];
            }
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

- (void)filterImageListAndUploadAndAddToImageCategory:(PFObject *)imageCategory {
    NSString *catTag = imageCategory[@"tag"];
    
    NSPredicate *filter = [NSPredicate predicateWithBlock:^BOOL(PQImage *evaluatedObject, NSDictionary *bindings) {
        return [[evaluatedObject category] isEqualToString:catTag];
    }];
    
    NSArray *filteredImages = [_images filteredArrayUsingPredicate:filter];
    
    NSLog(@"Filtered %lu images for category %@", (unsigned long)[filteredImages count], catTag);
    if ([filteredImages count] != 0) {
        for (PQImage *image in filteredImages) {
            [image uploadImageAndSuccess:^(PFObject *uploadObject) {
                
                NSLog(@"%@ - Start adding object to category: %@", image.fileName, catTag);
                [imageCategory addObject:uploadObject forKey:@"imageArray"];
                [imageCategory saveInBackground];
                NSLog(@"%@ - ALL DONE!", image.fileName);
                ++_count;
                NSLog(@"%i/%lu", _count, (unsigned long)[_images count]);
            }
                              andFailure:^(NSError *error) {
                                  NSLog(@"%@ - Failed adding object to category: %@", image.fileName, catTag);
                              }];
        }
    }
}

#pragma mark - Tableview Delegates


@end
