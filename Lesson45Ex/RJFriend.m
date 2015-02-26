//
//  RJFriend.m
//  Lesson45Ex
//
//  Created by Hopreeeeenjust on 25.02.15.
//  Copyright (c) 2015 Hopreeeeenjust. All rights reserved.
//

#import "RJFriend.h"

@implementation RJFriend

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.firstName = [dictionary valueForKey:@"first_name"];
        self.lastName = [dictionary valueForKey:@"last_name"];
        self.imageUrl = [dictionary valueForKey:@"photo_100"];
        self.originalImageUrl = [dictionary valueForKey:@"photo_max"];
        self.friendID = [[dictionary valueForKey:@"id"] integerValue];
        self.birthDate = [dictionary valueForKey:@"bdate"];
        self.city = [dictionary valueForKeyPath:@"city.title"];
        self.country = [dictionary valueForKeyPath:@"country.title"];
        self.lastSeen = [[dictionary valueForKeyPath:@"last_seen.time"] integerValue];
        self.online = [[dictionary valueForKey:@"online"] integerValue];
        self.onlineMobile = [[dictionary valueForKey:@"online_mobile"] integerValue];
    }
    return self;
}
@end
