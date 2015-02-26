//
//  RJServerManager.m
//  Lesson45Ex
//
//  Created by Hopreeeeenjust on 25.02.15.
//  Copyright (c) 2015 Hopreeeeenjust. All rights reserved.
//

#import "RJServerManager.h"
#import "AFHTTPRequestOperationManager.h"

@interface RJServerManager ()
@property (strong, nonatomic) AFHTTPRequestOperationManager *requestOperationManager;
@end

@implementation RJServerManager

+ (RJServerManager *)sharedManager {
    static RJServerManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [RJServerManager new];
    });
    return manager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSString *urlString = @"https://api.vk.com/method/";
        NSURL *url = [NSURL URLWithString:urlString];
        self.requestOperationManager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:url];
    }
    return self;
}

- (void) getFriendsWithCount:(NSInteger)count
                   andOffset:(NSInteger)offset
                   onSuccess:(void(^)(NSArray *friends))success
                   onFailure:(void(^)(NSError *error, NSInteger statusCode))failure {
    NSDictionary *parameters = @{
                                 @"user_id": @"6054746",
                                 @"order": @"name",
                                 @"count": @(count),
                                 @"offset": @(offset),
                                 @"fields": @[@"photo_100", @"online"],
                                 @"name_case": @"nom",
                                 @"v": (@5.8)};

    [self.requestOperationManager GET:@"friends.get?"
                           parameters:parameters
                              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                  NSArray *friends = [[responseObject valueForKey:@"response"] valueForKey:@"items"];
                                  if (success) {
                                      success(friends);
                                  }
                              }
                              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                  failure(error, error.code);
                              }];
}

- (void) getFriendInfoForId:(NSInteger)friendId
                   onSuccess:(void(^)(NSArray *friendsInfo))success
                   onFailure:(void(^)(NSError *error, NSInteger statusCode))failure {
    NSDictionary *parameters = @{
                                 @"user_ids": @(friendId),
                                 @"fields": @[@"photo_100", @"bdate", @"city", @"country", @"photo_max", @"online", @"online_mobile", @"last_seen"],
                                 @"name_case": @"nom",
                                 @"v": (@5.8)};
    
    [self.requestOperationManager GET:@"users.get?"
                           parameters:parameters
                              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                  NSArray *friends = [responseObject valueForKey:@"response"];
                                  if (success) {
                                      success(friends);
                                  }
                              }
                              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                  failure(error, error.code);
                              }];
}


@end

