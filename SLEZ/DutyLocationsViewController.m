//
//  DutiesViewController.m
//  SLEZ
//
//  Created by rey on 10/9/22.
//

#import "DutyLocationsViewController.h"
#import "DutyStudentsViewController.h"

@interface DutyLocationsViewController ()

@end

@implementation DutyLocationsViewController

- (int)getDaysSinceSunday {
    time_t t = time(0);
    struct tm* tm = gmtime(&t);
    return tm->tm_wday;
}

- (void)loadRosterForDay:(int)day {
    [[self.collection documentWithPath:[NSString stringWithFormat:@"%d", day]] getDocumentWithCompletion:^(FIRDocumentSnapshot * _Nullable snapshot, NSError * _Nullable error) {
        if (error) {
            NSLog(@"Error while loading document: %@", error);
            self.otherLabel.text = [NSString stringWithFormat:@"Could not load roster: %@", error.localizedDescription];
            self.tableView.layer.opacity = 0;
            return;
        }
        if (!snapshot.exists) {
            NSLog(@"Document does not exist");
            self.otherLabel.text = @"Duty roster does not exist. Contact siosinofficialbusiness@gmail.com and tell us about this.";
            self.tableView.layer.opacity = 0;
            return;
        }
        NSLog(@"Data: %@", snapshot.data);
        self.dutyTakers = snapshot.data;
        
        [self.tableView reloadData];
        self.tableView.layer.opacity = 1;
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.overrideUserInterfaceStyle = UIUserInterfaceStyleDark;
    
    // Do any additional setup after loading the view.
    self.store = defaultFirestore;
    
    self.collection = [self.store collectionWithPath:@"duties"];
    
//    __block const DutiesViewController* delegateAndDataSource = self;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.layer.opacity = 0;
    
    self.day = [self getDaysSinceSunday];
    self.otherLabel.text = @"Fetching...";
    [[self.collection documentWithPath:@"locations"] getDocumentWithCompletion:^(FIRDocumentSnapshot * _Nullable snapshot, NSError * _Nullable error) {
        if (error) {
            NSLog(@"Error while loading locations: %@", error);
            self.otherLabel.text = [NSString stringWithFormat:@"Error occurred when loading location list:\n\n%@", error.localizedDescription];
            self.tableView.layer.opacity = 0;
            return;
        }
        if (!snapshot.exists) {
            NSLog(@"Locations document does not exist");
            self.otherLabel.text = @"Location list does not exist. Contact siosinofficialbusiness@gmail.com and tell us about this.";
            self.tableView.layer.opacity = 0;
            return;
        }
        NSLog(@"Locations: %@", snapshot.data);
        self.dutyLocations = (NSArray<NSString*>*)(snapshot.data[@"value"]);
        
        if (self.day == 0 || self.day == 6) self.day = 1;
        
        [self loadRosterForDay:self.day];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dutyLocations.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    UIView* statusIndicator = [cell.contentView viewWithTag:2];
    UILabel* locationLabel = [cell.contentView viewWithTag:1];
    
    NSString* location = self.dutyLocations[indexPath.row];
    locationLabel.text = location;
    statusIndicator.hidden = true;
    if ([self.dutyTakers[location] containsObject:currentUser.email]) {
        statusIndicator.hidden = false;
    }
    
    statusIndicator.layer.cornerRadius = statusIndicator.bounds.size.width / 2;
    statusIndicator.layer.cornerCurve = kCACornerCurveCircular;
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"Locations";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"Selected at %ld", (long)indexPath.row);
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    
    self.selectedLocation = indexPath.row;
    [self performSegueWithIdentifier:@"studentListSegue" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"studentListSegue"]) {
        DutyStudentsViewController* destVc = segue.destinationViewController;
        destVc.students = self.dutyTakers[self.dutyLocations[self.selectedLocation]];
    }
}


- (IBAction)segmentChanged:(UISegmentedControl*)sender {
    self.day = (int)(sender.selectedSegmentIndex + 1l);
    [self loadRosterForDay:self.day];
}

@end
