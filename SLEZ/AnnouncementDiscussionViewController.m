//
//  AnnouncementDiscussionViewController.m
//  SLEZ
//
//  Created by rey on 13/9/22.
//

#import "AnnouncementDiscussionViewController.h"

@interface AnnouncementDiscussionViewController ()

@end

@implementation AnnouncementDiscussionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
    self.shouldLoadComments = true;
    self.shouldLoadReplies = false;
    self.viewingReplies = false;
    self.comments = [@[] mutableCopy];
    self.replies = [@[] mutableCopy];
    self.commentRef = self.announcement.comments;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.view.overrideUserInterfaceStyle = UIUserInterfaceStyleDark;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.comments.count == 0 && self.shouldLoadComments) {
        self.shouldLoadComments = false;
        [self loadComments:10 beforeDate:self.comments.lastObject.creation outComments:self.comments completion:^(long count, NSError *error) {
            if (error) {
                NSLog(@"Error when loading comments: %@", error);
                self.shouldLoadComments = false;
                return;
            }
            NSLog(@"Loaded %ld comments", count);
            
            if (!count) self.shouldLoadComments = false;
            else self.shouldLoadComments = true;
            [self.tableView reloadData];
        }];
    }
    return self.comments.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"comment" forIndexPath:indexPath];
    
    UILabel* authorLabel = [cell.contentView viewWithTag:2];
    UITextView* infoView = [cell.contentView viewWithTag:3];
    
    if (indexPath.row + 1 >= self.comments.count && self.shouldLoadComments) {
        self.shouldLoadComments = false;
        [self loadComments:10 beforeDate:self.comments.lastObject.creation outComments:self.comments completion:^(long count, NSError *error) {
            if (error) {
                NSLog(@"Error when loading comments: %@", error);
                self.shouldLoadComments = false;
                return;
            }
            NSLog(@"Loaded %ld comments", count);
            
            if (!count) self.shouldLoadComments = false;
            else self.shouldLoadComments = true;
            [self.tableView reloadData];
        }];
    }
    
    authorLabel.text = self.comments[indexPath.row].author;
    infoView.text = self.comments[indexPath.row].info;
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"Comments";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    printf("User selected comment %ld\n", (long)indexPath.row);
    [tableView deselectRowAtIndexPath:indexPath animated:true];
}

- (void)loadComments:(NSInteger)count beforeDate:(NSDate*)date outComments:(NSMutableArray<Comment*>*)comments completion:(void(^)(long count, NSError* error))completion {
    FIRQuery* query;
    
    if (date) {
        
        query = [[[self.commentRef queryOrderedByField:@"creation" descending:true]
                  queryWhereField:@"creation" isLessThan:date]
                 queryLimitedTo:count];
    } else {
        query = [[self.commentRef queryOrderedByField:@"creation" descending:true]
                 queryLimitedTo:count];
    }
    
    [query getDocumentsWithCompletion:^(FIRQuerySnapshot * _Nullable snapshot, NSError * _Nullable error) {
        if (error) {
            completion(-1, error);
        } else {
            for (FIRQueryDocumentSnapshot* document in snapshot.documents) {
                NSString* repliesStr = [NSString stringWithFormat:@"%@/%@/replies", self.announcement.comments.path, document.documentID];
                FIRCollectionReference* replies = [defaultFirestore collectionWithPath:repliesStr];
                Comment* c = [[Comment alloc] initWithInfo:[document valueForField:@"info"]
                                                    author:[document valueForField:@"author"]
                                                  creation:[document valueForField:@"creation"]
                                                   replies:replies];
                [self.comments addObject:c];
            }
            completion(snapshot.count, error);
        }
    }];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:@"viewCommentsSegue"]) {
        [segue.destinationViewController setValue:self.announcement forKey:@"announcement"];
    }
}

@end


@implementation Comment

- (instancetype)initWithInfo:(NSString*)info author:(NSString*)author creation:(NSDate*)creation replies:(FIRCollectionReference*)replies {
    self = [super init];
    self.info = info;
    self.author = author;
    self.creation = creation;
    self.replies = replies;
    return self;
}

@end
