//
//  IdeaBoardDiscussionViewController.m
//  SLEZ
//
//  Created by rey on 18/9/22.
//

#import "IdeaBoardDiscussionViewController.h"
#include "IdeaWriteCommentViewController.h"

@interface IdeaBoardDiscussionViewController ()

@end

@implementation IdeaBoardDiscussionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.overrideUserInterfaceStyle = UIUserInterfaceStyleDark;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.commentRef = self.idea.comments;
    self.comments = [@[] mutableCopy];
    self.shouldLoadComments = true;
}

- (void)viewWillAppear:(BOOL)animated {
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.comments.count == 0 && self.shouldLoadComments) {
        self.shouldLoadComments = false;
        [self loadComments:10 beforeDate:nil outComments:self.comments completion:^(long count, NSError* error) {
            if (error) {
                NSLog(@"Failed to get comments: %@", error);
                return;
            }
            
            NSLog(@"Successfully got %ld comment", count);
            if (count) self.shouldLoadComments = true;
            [tableView reloadData];
        }];
    }
    return self.comments.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"comment" forIndexPath:indexPath];
    
    UIView* cellView = [cell.contentView viewWithTag:1];
    UILabel* authorLabel = [cellView viewWithTag:2];
    UITextView* infoView = [cellView viewWithTag:3];
    IdeaComment* comment = self.comments[indexPath.row];
    
    if (indexPath.row + 1 >= self.comments.count && self.shouldLoadComments) {
        self.shouldLoadComments = false;
        [self loadComments:10 beforeDate:self.comments.lastObject.creation outComments:self.comments completion:^(long count, NSError* error) {
            if (error) {
                NSLog(@"Failed to get comments: %@", error);
                return;
            }
            
            NSLog(@"Successfully got %ld comments", count);
            if (count) self.shouldLoadComments = true;
            [tableView reloadData];
        }];
    }
    
    authorLabel.text = comment.author;
    infoView.text = comment.info;
    
    return cell;
}

- (void)loadComments:(long)count beforeDate:(NSDate*)date outComments:(NSMutableArray<IdeaComment*>*)comments completion:(void(^)(long count, NSError* error))completion {
    FIRQuery* query;
    if (date) {
        query = [[[self.commentRef queryOrderedByField:@"creation" descending:true]
                  queryWhereField:@"creation" isLessThan:date]
                 queryLimitedTo:count];
    } else {
        query = [[self.commentRef queryOrderedByField:@"creation" descending:true] queryLimitedTo:count];
    }
    
    [query getDocumentsWithCompletion:^(FIRQuerySnapshot * _Nullable snapshot, NSError * _Nullable error) {
        if (error) {
            completion(-1, error);
            return;
        }
        for (FIRQueryDocumentSnapshot* comment in snapshot.documents) {
            IdeaComment* c = [[IdeaComment alloc] initWithInfo:[comment valueForField:@"info"]
                                                        author:[comment valueForField:@"author"]
                                                      creation:[comment valueForField:@"creation"]
                                                       replies:[comment.reference collectionWithPath:@"replies"]];
            [comments addObject:c];
        }
        completion(snapshot.count, error);
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//    return [NSString stringWithFormat:@"Comments (%ld)", (long)self.comments.count];
    return @"Comments";
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:@"ideaWriteCommentSegue"]) {
        IdeaWriteCommentViewController* destVc = segue.destinationViewController;
        destVc.idea = self.idea;
    }
}

@end
