//
//  RJFriendProfileController.m
//  Lesson45Ex
//
//  Created by Hopreeeeenjust on 25.02.15.
//  Copyright (c) 2015 Hopreeeeenjust. All rights reserved.
//

#import "RJFriendProfileController.h"
#import "RJServerManager.h"
#import "RJFriend.h"
#import "UIImageView+AFNetworking.h"

@interface RJFriendProfileController ()
@property (strong, nonatomic) RJFriend *friend;
@end

@implementation RJFriendProfileController

#pragma mark - View

- (void)viewDidLoad {
    [super viewDidLoad];
    self.photoImageView.layer.cornerRadius = CGRectGetHeight(self.photoImageView.bounds) / 2;
    self.photoImageView.clipsToBounds = YES;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.title = self.title;
    [self getFriendInfoFromServer];
    self.followersButton.layer.cornerRadius = 5;
    self.followersButton.clipsToBounds = YES;
    self.followingButton.layer.cornerRadius = 5;
    self.followingButton.clipsToBounds = YES;
    self.groupsButton.layer.cornerRadius = 5;
    self.groupsButton.clipsToBounds = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - API

- (void)getFriendInfoFromServer {
    [[RJServerManager sharedManager]
     getFriendInfoForId:self.userID
     onSuccess:^(NSArray *friendsInfo) {
         NSDictionary *userInfo = [friendsInfo firstObject];
         RJFriend *friend = [[RJFriend alloc] initWithDictionary:userInfo];
         self.friend = friend;
         [self.photoImageView setImageWithURL:[NSURL URLWithString:friend.originalImageUrl]];
         self.nameLabel.text = [NSString stringWithFormat:@"%@ %@", friend.firstName, friend.lastName];
         if (friend.city) {
             self.cityLabel.text = [NSString stringWithFormat:@"%@, %@", [friend.city substringToIndex:friend.city.length - 1], friend.country];
         }
         if (friend.online) {
             if (friend.onlineMobile) {
                 self.statusLabel.text = @"Online (mob.)";
             } else {
                 self.statusLabel.text = @"Online";
             }
         } else {
             self.statusLabel.text = [self statusText];
         }
         if (friend.birthDate.length > 5) {    //we got full date of birth
             self.ageLabel.text = [self showAge];
         }
         UIView *view = [self.statusLabel superview];
         [view reloadInputViews];
     }
     onFailure:^(NSError *error, NSInteger statusCode) {
         NSLog(@"Error = %@, code = %ld", [error localizedDescription], statusCode);

     }];
}

#pragma mark - Methods

- (NSString *)statusText {
    NSString *status = nil;
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"dd/MM/yyyy"];
    NSTimeZone *tz = [NSTimeZone localTimeZone];
    [formatter setTimeZone:tz];
    NSString *date = [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:self.friend.lastSeen]];
    NSDateFormatter *justTimeFormatter = [NSDateFormatter new];
    [justTimeFormatter setDateFormat:@"HH:mm"];
    [justTimeFormatter setTimeZone:tz];
    NSString *time = [justTimeFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:self.friend.lastSeen]];
    NSInteger gap = [[NSDate dateWithTimeIntervalSinceNow:0] timeIntervalSinceDate:[NSDate dateWithTimeIntervalSince1970:self.friend.lastSeen]];
    switch (gap) {
        case 0 ... 59:
            status = [NSString stringWithFormat:@"Last seen %ld seconds ago", gap];
            break;
        case 60 ... 3599:
            status = [NSString stringWithFormat:@"Last seen %ld minutes ago", gap / 60];
            break;
        case 3600 ... (3600 * 2 - 1):
            status = [NSString stringWithFormat:@"Last seen %ld hour ago", gap / 60 / 60];
            break;
        case 3600 * 2 ... (3600 * 4 - 1):
            status = [NSString stringWithFormat:@"Last seen %ld hours ago", gap / 60 / 60];
            break;
        case 3600 * 4 ... (3600 * 24 - 1):
            status = [NSString stringWithFormat:@"Last seen today on %@", time];
            break;
        default:
            status = [NSString stringWithFormat:@"Last seen on %@", date];
            break;
    }
    return status;
}

- (NSString *)showAge {
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"dd/MM/yyyy"];
    NSDate *date = [formatter dateFromString:self.friend.birthDate];
    NSInteger age = (NSInteger)(([[NSDate dateWithTimeIntervalSinceNow:0] timeIntervalSinceDate:date]) / 60 / 60 / 24 / 365.25);
    if (age % 10 == 1) {
        return [NSString stringWithFormat:@"%ld year", age];

    } else {
        return [NSString stringWithFormat:@"%ld years", age];
    }
}

@end
