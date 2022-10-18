//
//  IdeaBoardViewController.m
//  SLEZ
//
//  Created by rey on 11/9/22.
//

#import "IdeaBoardViewController.h"
#import "IdeaDetailViewController.h"

@interface IdeaBoardViewController ()

@end

@implementation IdeaBoardViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.overrideUserInterfaceStyle = UIUserInterfaceStyleDark;
    
    self.boardIds = @[@"/ideas-psb", @"/ideas-ace", @"/ideas-sc", @"/ideas-house"];
    self.boardTitles = @[@"PSB Idea Board", @"ACE Idea Board", @"SC Idea Board", @"House Idea Board"];
    self.selectedBoard = self.boardIds[0];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.collection = [defaultFirestore collectionWithPath:self.selectedBoard];
    self.shouldLoadIdeas = true;
    self.otherLabel.text = @"Fetching...";
    self.tableView.hidden = true;
    self.ideas = [@[] mutableCopy];
}

- (IBAction)segmentChanged:(UISegmentedControl*)sender {
    self.selectedBoard = self.boardIds[sender.selectedSegmentIndex];
    self.shouldLoadIdeas = true;
    self.collection = [defaultFirestore collectionWithPath:self.selectedBoard];
    [self.ideas removeAllObjects];
    self.boardTitleLabel.text = self.boardTitles[sender.selectedSegmentIndex];
    [self loadIdeas:10 beforeDate:nil creation:^(long count, NSError *error) {
        if (error) {
            self.shouldLoadIdeas = false;
            NSLog(@"Error occurred getting ideas: %@", error);
            self.otherLabel.text = error.localizedDescription;
            self.tableView.hidden = true;
            return;
        }
        
        self.tableView.hidden = false;
        if (count == 0) {
            self.shouldLoadIdeas = false;
        } else {
            self.shouldLoadIdeas = true;
        }
        
        [self.tableView reloadData];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.ideas.count == 0 && self.shouldLoadIdeas) {
        self.shouldLoadIdeas = false;
        [self loadIdeas:10 beforeDate:nil creation:^(long count, NSError *error) {
            if (error) {
                self.shouldLoadIdeas = false;
                NSLog(@"Error occurred getting ideas: %@", error);
                self.otherLabel.text = error.localizedDescription;
                self.tableView.hidden = true;
                return;
            }
            
            self.tableView.hidden = false;
            if (count) self.shouldLoadIdeas = true;
            
            [self.tableView reloadData];
        }];
    }
    return self.ideas.count;
}

- (void)upvoteAnnouncement:(UIButton*)sender {
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell;
    UIView* cellView;
    
    /* if ([self.ideas[indexPath.row].author isEqualToString:currentUser.email]) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"ideaOwner" forIndexPath:indexPath];
        cellView = [cell.contentView viewWithTag:1];
        UIButton* deleteButton = [cellView viewWithTag:4];
        [deleteButton addTarget:self action:@selector(deleteIdea:) forControlEvents:UIControlEventTouchUpInside];
    } else */ {
        cell = [tableView dequeueReusableCellWithIdentifier:@"idea" forIndexPath:indexPath];
        cellView = [cell.contentView viewWithTag:1];
    }
    
    UILabel* titleLabel = [cellView viewWithTag:2];
    UILabel* infoLabel = [cellView viewWithTag:3];
    UIButton* downvoteButton = [cellView viewWithTag:100];
    UIButton* upvoteButton = [cellView viewWithTag:101];
    
    [downvoteButton addTarget:self action:@selector(upvoteAnnouncement:) forControlEvents:UIControlEventTouchUpInside];
    
    cellView.layer.cornerRadius = cell.layer.cornerRadius = 16;
    cellView.layer.cornerCurve = cell.layer.cornerCurve = kCACornerCurveContinuous;
    cellView.layer.borderWidth = 2;
    cellView.layer.borderColor = UIColor.grayColor.CGColor;
    
    Idea* idea = self.ideas[indexPath.row];
    
    if (indexPath.row + 1 >= self.ideas.count && self.shouldLoadIdeas) {
        self.shouldLoadIdeas = false;
        [self loadIdeas:10 beforeDate:self.ideas.lastObject.creation creation:^(long count, NSError *error) {
            if (error) {
                self.shouldLoadIdeas = false;
                NSLog(@"Error occurred getting ideas: %@", error);
                self.otherLabel.text = error.localizedDescription;
                self.tableView.hidden = true;
                return;
            }
            
            self.tableView.hidden = false;
            if (count) self.shouldLoadIdeas = true;
            
            [self.tableView reloadData];
        }];
    }
    
    titleLabel.text = idea.title;
    infoLabel.text = idea.info;
    
    return cell;
}

- (void)deleteIdea:(UIButton*)sender {
    long index = [self.tableView indexPathForCell:(UITableViewCell*)(sender.superview.superview.superview)].row;
    NSLog(@"Deleting idea %ld", index);
}

- (void)loadIdeas:(NSInteger)count beforeDate:(NSDate*)date creation:(void (^)(long count, NSError* error))completion {
    FIRQuery* query;
    
    if (date) {
        query = [[self.collection
         queryOrderedByField:@"creation" descending:true]
        queryWhereField:@"creation" isLessThan:self.ideas.lastObject.creation];
    } else {
        query = [self.collection queryOrderedByField:@"creation" descending:true];
    }
    
    [query getDocumentsWithCompletion:^(FIRQuerySnapshot * _Nullable snapshot, NSError * _Nullable error) {
        if (error) {
            completion(-1, error);
        }
        for (FIRQueryDocumentSnapshot* document in snapshot.documents) {
            [self.ideas addObject:[[Idea alloc] initWithTitle:[document valueForField:@"title"]
                                                         info:[document valueForField:@"info"]
                                                       author:[document valueForField:@"author"]
                                                     creation:[document valueForField:@"creation"]
                                                     comments:[document.reference collectionWithPath:@"discussion"]]];
        }
        completion(snapshot.count, error);
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    self.selectedIdea = indexPath.row;
    [self performSegueWithIdentifier:@"showIdeaDetailSegue" sender:self];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:@"showIdeaDetailSegue"]) {
        IdeaDetailViewController* destVc = segue.destinationViewController;
        destVc.idea = self.ideas[self.selectedIdea];
    }
}


@end

