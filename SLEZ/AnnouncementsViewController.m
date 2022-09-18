//
//  AnnouncementsViewController.m
//  SLEZ
//
//  Created by rey on 10/9/22.
//

#import "AnnouncementsViewController.h"
#import "AnnouncementViewController.h"

@interface AnnouncementsViewController ()

@end

@implementation AnnouncementsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.overrideUserInterfaceStyle = UIUserInterfaceStyleDark;
    
    // Do any additional setup after loading the view.
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.store = defaultFirestore;
    
    self.announcements = [@[] mutableCopy];
    
    self.shouldLoadAnnouncements = true;
}


#pragma mark - Table View

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    if (!self.announcements.count && self.shouldLoadAnnouncements) {
        self.shouldLoadAnnouncements = false;
        [self loadAnnouncementsAndReload:10 beforeDate:nil outAnnouncements:self.announcements completion:^(long loaded, NSError* error) {
            if (error) {
                NSLog(@"Error getting announcements: %@", error);
                return;
            }
            if (loaded) self.shouldLoadAnnouncements = true;
            [tableView reloadData];
            
        }];
    }
    return self.announcements.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell* cell;
    UIView* cellView;
    
    if ([self.announcements[indexPath.row].author isEqual:currentUser.email]) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"announcementOwner" forIndexPath:indexPath];
        cellView = [cell.contentView viewWithTag:1];
        UIButton* deleteButton = [cellView viewWithTag:4];
        [deleteButton addTarget:self action:@selector(deleteAnnouncement:) forControlEvents:UIControlEventTouchUpInside];
        deleteButton.tag = indexPath.row;
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"announcement" forIndexPath:indexPath];
        cellView = [cell.contentView viewWithTag:1];
    }
    
    UILabel* titleLabel = [cellView viewWithTag:2];
    UILabel* infoLabel = [cellView viewWithTag:3];
    
    if (self.announcements[indexPath.row].important) {
        UIColor* gcol = [UIColor colorNamed:@"appGoldenColor3"];
        CGFloat gcol_comps[4];
        [gcol getRed:gcol_comps green:&gcol_comps[1] blue:&gcol_comps[2] alpha:&gcol_comps[3]];
        UIColor* gcol_trans = [UIColor colorWithRed:gcol_comps[0] green:gcol_comps[1] blue:gcol_comps[2] alpha:0.4];
        cellView.backgroundColor = gcol_trans;
        cellView.layer.borderColor = UIColor.systemYellowColor.CGColor;
    } else {
        UIColor* gcol = [UIColor systemGrayColor];
        CGFloat gcol_comps[4];
        [gcol getRed:gcol_comps green:&gcol_comps[1] blue:&gcol_comps[2] alpha:&gcol_comps[3]];
        UIColor* gcol_trans = [UIColor colorWithRed:gcol_comps[0] green:gcol_comps[1] blue:gcol_comps[2] alpha:0.4];
        cellView.backgroundColor = gcol_trans;
        cellView.layer.borderColor = UIColor.lightGrayColor.CGColor;
    }
    
    cellView.layer.cornerRadius = cell.layer.cornerRadius = 16;
    cellView.layer.cornerCurve = cell.layer.cornerCurve = kCACornerCurveContinuous;
    cellView.layer.borderWidth = 2;
    
    titleLabel.text = self.announcements[indexPath.row].title;
    infoLabel.text = self.announcements[indexPath.row].info;
    
    if (indexPath.row + 1 == self.announcements.count && self.shouldLoadAnnouncements) {
        self.shouldLoadAnnouncements = false;
        [self loadAnnouncementsAndReload:10 beforeDate:self.announcements.lastObject.creation outAnnouncements:self.announcements completion:^(long loaded, NSError* error) {
            if (error) {
                NSLog(@"Error getting announcements: %@", error);
                return;
            }
            if (loaded) self.shouldLoadAnnouncements = true;
            [tableView reloadData];
            
        }];
    }
    
    return cell;
}

- (void)deleteAnnouncement:(UIButton*)sender {
    NSUInteger index = [self.tableView indexPathForCell:(UITableViewCell*)(sender.superview.superview.superview)].row;
    NSLog(@"Deleting announcement %ld", index);
    
    FIRDocumentReference* announcement = self.announcements[index].comments.parent;
    FIRCollectionReference* comments = [announcement collectionWithPath:@"discussion"];
    
    // Delete replies and comments
    [comments getDocumentsWithCompletion:^(FIRQuerySnapshot * _Nullable snapshot, NSError * _Nullable error) {
        if (error) {
            NSLog(@"Unable to access comments and replies");
            return;
        }
        
        FIRWriteBatch* commentBatch = [defaultFirestore batch];
        for (long _i = 0; _i < snapshot.documents.count; _i++) {
            FIRQueryDocumentSnapshot* comment = snapshot.documents[_i];
            FIRCollectionReference* replies = [comment.reference collectionWithPath:@"replies"];
            
            [commentBatch deleteDocument:comment.reference];
            
            [replies getDocumentsWithCompletion:^(FIRQuerySnapshot * _Nullable snapshot, NSError * _Nullable error) {
                if (error) {
                    NSLog(@"Unable to access replies for comment: %@", error);
                    return;
                }
                long maxBatchCount = 500;
                long replyBatchCount = snapshot.count / maxBatchCount;
                long leftover = snapshot.count - replyBatchCount * maxBatchCount;
                for (long i = 0; i < replyBatchCount; i++) {
                    FIRWriteBatch* batch = [defaultFirestore batch];
                    for (long i2 = 0; i2 < maxBatchCount; i2++)
                        [batch deleteDocument:snapshot.documents[i * maxBatchCount + i2].reference];
                    
                    [batch commitWithCompletion:^(NSError * _Nullable error) {
                        if (error) {
                            NSLog(@"Error deleting replies: %@", error);
                            return;
                        }
                        NSLog(@"Successfully deleted %ld replies", maxBatchCount);
                    }];
                }
                
                FIRWriteBatch* batch = [defaultFirestore batch];
                for (long i = 0; i < leftover; i++)
                    [batch deleteDocument:snapshot.documents[replyBatchCount * maxBatchCount + i].reference];
                
                [batch commitWithCompletion:^(NSError * _Nullable error) {
                    if (error) {
                        NSLog(@"Error deleting replies: %@", error);
                        return;
                    }
                    NSLog(@"Successfully deleted %ld replies", leftover);
                    
                    if (_i == snapshot.documents.count - 1) {
                        [commentBatch commitWithCompletion:^(NSError * _Nullable error) {
                            if (error) {
                                NSLog(@"Failed to delete comment: %@", error);
                                return;
                            }
                            
                            NSLog(@"Deleted comments");
                            
                            [announcement deleteDocumentWithCompletion:^(NSError * _Nullable error) {
                                if (error) {
                                    NSLog(@"Failed to delete announcement %ld: %@", (long)index, error);
                                    return;
                                }
                                NSLog(@"Deleted announcement %ld", index);
                                NSArray<NSIndexPath*>* rowsToDelete = @[[NSIndexPath indexPathForRow:index inSection:0]];
                                
                                [self.announcements removeObjectAtIndex:index];
                                [self.tableView beginUpdates];
                                [self.tableView deleteRowsAtIndexPaths:rowsToDelete withRowAnimation:UITableViewRowAnimationLeft];
                                [self.tableView endUpdates];
                            }];
                        }];
                    }
                }];
            }];
        }
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    printf("User selected announcement %ld\n", (long)indexPath.row);
    [self performSegueWithIdentifier:@"viewAnnouncementSegue" sender:indexPath];
    [tableView deselectRowAtIndexPath:indexPath animated:true];
}

- (void)loadAnnouncementsAndReload:(long)count beforeDate:(NSDate*)date outAnnouncements:(NSMutableArray<Announcement*>*)announcements completion:(void(^)(long loaded, NSError* error))completion {
    FIRCollectionReference* collection = [self.store collectionWithPath:@"/announcements"];
    FIRQuery* query;
    
    if (date) {
        query = [[[collection
                   queryWhereField:@"creation" isLessThan:date]
                  queryOrderedByField:@"creation" descending:true]
                 queryLimitedTo:count];
    } else {
        query = [[collection
                  queryOrderedByField:@"creation" descending:true]
                 queryLimitedTo:count];
    }
    
    [query getDocumentsWithCompletion:^(FIRQuerySnapshot * _Nullable snapshot, NSError * _Nullable error) {
        long loaded = 0;
        if (error) {
            NSLog(@"Error loading more announcements!");
            loaded = -1;
        } else {
            NSLog(@"Loaded %lu annonucements", (unsigned long)snapshot.documents.count);
            loaded = snapshot.documents.count;
            for (FIRQueryDocumentSnapshot* document in snapshot.documents) {
                FIRCollectionReference* comments = [[collection documentWithPath:document.documentID] collectionWithPath:@"discussion"];
                Announcement* a = [[Announcement alloc] initWithTitle:[document valueForField:@"title"]
                                                                 info:[document valueForField:@"info"]
                                                             creation:[document valueForField:@"creation"]
                                                               author:[document valueForField:@"author"]
                                                             comments:comments
                                                            important:((NSNumber*)[document valueForField:@"important"]).boolValue];
                [announcements addObject:a];
            }
        }
        
        completion(loaded, error);
    }];
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:@"viewAnnouncementSegue"]) {
        AnnouncementViewController* destVc = [segue destinationViewController];
        destVc.announcement = self.announcements[((NSIndexPath*)sender).row];
    }
}

@end

@implementation Announcement

- (instancetype)initWithTitle:(NSString*)title info:(NSString*)info creation:(NSDate*)creation author:(NSString*)author comments:(FIRCollectionReference*)comments important:(BOOL)important {
    self = [super init];
    
    self.title = title;
    self.info = info;
    self.creation = creation;
    self.important = important;
    self.author = author;
    self.comments = comments;
    
    return self;
}

@end
