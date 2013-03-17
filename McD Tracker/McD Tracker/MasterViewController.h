//
//  MasterViewController.h
//  McD Tracker
//
//  Created by Pradyumna Doddala on 5/26/12.
//  Copyright (c) 2012 Pradyumna Doddala. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <QuartzCore/QuartzCore.h>
#import <iAd/iAd.h>


@class DetailViewController;
@class iADView;
@interface MasterViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,ADBannerViewDelegate>

@property (retain, nonatomic) DetailViewController *detailViewController;

@property (retain, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (retain, nonatomic) NSArray *fetchedObjects;
@property (retain, nonatomic) id detailItem;
@property (retain, nonatomic) ADBannerView *adBannerView;
@property (nonatomic, retain) IBOutlet UITableView *tableView;
@end
