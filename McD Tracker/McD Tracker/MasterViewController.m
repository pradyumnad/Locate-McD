//
//  MasterViewController.m
//  McD Tracker
//
//  Created by Pradyumna Doddala on 5/26/12.
//  Copyright (c) 2012 Pradyumna Doddala. All rights reserved.
//

#import "MasterViewController.h"
#import "Store.h"
#import "UINavigationBar+Custom.h"
#import "PDLocationsMapViewController.h"
#import "PDLocation.h"

@interface MasterViewController ()
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
@end

@implementation MasterViewController

@synthesize detailViewController = _detailViewController;
@synthesize managedObjectContext = __managedObjectContext;
@synthesize fetchedObjects = __fetchedObjects;
@synthesize detailItem= _detailItem;
@synthesize tableView;
@synthesize adBannerView = _adBannerView;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"McD", @"McD");
    }
    return self;
}

- (void)dealloc
{
    
    [__fetchedObjects release];
    [_detailViewController release];
    [__managedObjectContext release];
    [_adBannerView release];

    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"%@", [NSValue valueWithCGRect:[UIScreen mainScreen].bounds]);
    _adBannerView = [[ADBannerView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, 320, 50.0)];
    _adBannerView.delegate = self;
    [self.view addSubview:_adBannerView];
    [self.view bringSubviewToFront:self.adBannerView];

    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"McD"
                                                                   style:UIBarButtonItemStyleBordered
                                                                  target:self
                                                                  action:@selector(popViewControllerAnimated:)];
    if ([backButton respondsToSelector:@selector(setTintColor:)]) {
        [backButton setTintColor:[UIColor redColor]];
    }
    
    self.navigationItem.backBarButtonItem = backButton;
    //UITableview shadow
    
    CGColorRef darkColor = [[UIColor blackColor] colorWithAlphaComponent:.5f].CGColor;
    CGColorRef lightColor = [UIColor clearColor].CGColor;
    
    //Footer shadow
    UIView *footerShadow = [[UIView alloc] initWithFrame:CGRectMake(0, 10, 320, 0)];
    
    CAGradientLayer *bottomShadow = [[[CAGradientLayer alloc] init] autorelease];
    bottomShadow.frame = CGRectMake(0, 10, self.view.frame.size.width, 10);
    bottomShadow.colors = [NSArray arrayWithObjects:(id)darkColor, (id)lightColor, nil];
    footerShadow.alpha = 0.6;
    
    [footerShadow.layer addSublayer:bottomShadow];
    self.tableView.tableFooterView = footerShadow;
    
    //Header shadow
    UIView *headerShadow = [[UIView alloc] initWithFrame:CGRectMake(0, -10, 320, 0)];
    
    CAGradientLayer *topShadow = [[[CAGradientLayer alloc] init] autorelease];
    topShadow.frame = CGRectMake(0, -10, self.view.frame.size.width, 10);
    topShadow.colors = [NSArray arrayWithObjects:(id)lightColor, (id)darkColor, nil];
    headerShadow.alpha = 0.6;
    
    [headerShadow.layer addSublayer:topShadow];
    self.tableView.tableHeaderView = headerShadow;
    
    
	// Do any additional setup after loading the view, typically from a nib.
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Store"
                                              inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    [fetchRequest setResultType:NSDictionaryResultType];
    [fetchRequest setReturnsDistinctResults:YES];
    [fetchRequest setPropertiesToFetch:[NSArray arrayWithObjects:@"city", nil]];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"city"
                                                                   ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSError *error = nil;
    NSArray *fetchedObjects = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects == nil) {
        // Handle the error
    }
    
    self.fetchedObjects = fetchedObjects;
    [fetchRequest release];
    [sortDescriptor release];
    [sortDescriptors release];
    
    [self.tableView reloadData];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark - TableView Methods
// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.fetchedObjects count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.font = [UIFont fontWithName:@"Marker Felt" size:20.0f];
        
        cell.textLabel.layer.shadowColor = [UIColor redColor].CGColor;
        cell.textLabel.layer.shadowRadius = 3.0f;
        cell.textLabel.layer.shadowOpacity = 0.6f;
        cell.textLabel.layer.shadowOffset = CGSizeMake(0.0, 0.0);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
//    void (^glowLabel)(UILabel *) = ^(UILabel *label) {
//        label.layer.shadowColor = [UIColor redColor].CGColor;
//        label.layer.shadowRadius = 3.0f;
//        label.layer.shadowOpacity = 0.6f;
//        label.layer.shadowOffset = CGSizeMake(0.0, 0.0);
//    };
//    
//    glowLabel(cell.textLabel);
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _detailItem = [self.fetchedObjects objectAtIndex:indexPath.row];
    PDLocationsMapViewController *locationsMapViewController = [[PDLocationsMapViewController alloc] initWithDelegate:self andDataSource:self];
    [self.navigationController pushViewController:locationsMapViewController animated:YES];
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    id store = [self.fetchedObjects objectAtIndex:indexPath.row];
    cell.textLabel.text = [store valueForKey:@"city"];
}

#pragma mark -
#pragma mark PDLocationsMapView

- (NSArray *)locationsForShowingInLocationsMap {
    
    NSArray *nearLocations = [self fetchedNearRecords:_detailItem];
    [nearLocations retain];
    
    NSMutableArray *locations = [NSMutableArray new];
    
    for (id store in nearLocations){
        PDLocation *loc = [[PDLocation alloc] initWithName:[store valueForKey:@"store"] description:@"" andLocation:CLLocationCoordinate2DMake([[store valueForKey:@"latitude"] floatValue],[[store valueForKey:@"longitude"] floatValue])];
        NSLog(@"%@,%@",loc,[store valueForKey:@"latitude"]);
        [locations addObject:loc];
    }
    return locations;
}

- (NSArray *)fetchedNearRecords:(id)detailItem{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Store"
                                              inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    [fetchRequest setResultType:NSDictionaryResultType];
    [fetchRequest setReturnsDistinctResults:YES];
    [fetchRequest setPropertiesToFetch:[NSArray arrayWithObjects:@"store", @"latitude", @"longitude", @"address", nil]];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"store"
                                                                   ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"city = %@", [detailItem valueForKey:@"city"]];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *fetchedObjects = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects == nil) {
        // Handle the error
        
    }

    [fetchRequest release];
    [sortDescriptor release];
    [sortDescriptors release];
    return fetchedObjects;
}
#pragma mark -
#pragma mark iAd

- (void)bannerViewWillLoadAd:(ADBannerView *)banner {
}

- (void)bannerViewDidLoadAd:(ADBannerView *)banner {
    [self tableviewFrameAdjustWithHeight:YES];
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error {
    [self tableviewFrameAdjustWithHeight:NO];
}

- (BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave {
    return YES;
}

- (void)bannerViewActionDidFinish:(ADBannerView *)banner {
    
}

- (void)tableviewFrameAdjustWithHeight:(BOOL)yes {
    NSLog(@"%@", [NSValue valueWithCGRect:_adBannerView.frame]);
    if(yes) {
        [self moveTo:CGPointMake(0, [UIScreen mainScreen].bounds.size.height-115.0f) duration:0.35f option:UIViewAnimationOptionCurveEaseInOut];
    } else {
        [self moveTo:CGPointMake(0, [UIScreen mainScreen].bounds.size.height) duration:0.35f option:UIViewAnimationOptionCurveEaseInOut];
    }
}

- (void) moveTo:(CGPoint)destination duration:(float)secs option:(UIViewAnimationOptions)option
{
    NSLog(@"%@", [NSValue valueWithCGPoint:destination]);
    [UIView animateWithDuration:secs delay:0.0 options:option
                     animations:^{
                         _adBannerView.frame = CGRectMake(destination.x,destination.y,
                                                          _adBannerView.frame.size.width,
                                                          _adBannerView.frame.size.height);
                     }
                     completion:^(BOOL finished) {
                         [self.view bringSubviewToFront:self.adBannerView];
                     }];
}

@end
