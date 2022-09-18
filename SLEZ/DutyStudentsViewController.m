//
//  DutyStudentsViewController.m
//  SLEZ
//
//  Created by rey on 11/9/22.
//

#import "DutyStudentsViewController.h"

@interface DutyStudentsViewController ()

@end

@implementation DutyStudentsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.overrideUserInterfaceStyle = UIUserInterfaceStyleDark;
    
    // Do any additional setup after loading the view.
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.students.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    UILabel* studentName = [cell.contentView viewWithTag:1];
    studentName.text = self.students[indexPath.row];
    
    return cell;
}

@end
