//
//  Idea.m
//  SLEZ
//
//  Created by rey on 18/9/22.
//

#import <Foundation/Foundation.h>

#import "IdeaHead.h"

@implementation Idea

- (instancetype)initWithTitle:(NSString*)title info:(NSString*)info author:(NSString*)author creation:(NSDate*)creation comments:(FIRCollectionReference*)comments {
    self = [super init];
    
    self.title = title;
    self.info = info;
    self.author = author;
    self.creation = creation;
    self.comments = comments;
    
    return self;
}

@end

@implementation IdeaComment


- (instancetype)initWithInfo:(NSString *)info author:(NSString *)author creation:(NSDate *)creation replies:(FIRCollectionReference *)replies {
    self = [super init];
    
    self.info = info;
    self.author = author;
    self.creation = creation;
    self.replies = replies;
    
    return self;
}

@end

@implementation IdeaReply


- (instancetype)initWithInfo:(NSString *)info author:(NSString *)author creation:(NSDate *)creation {
    self = [super init];
    
    self.info = info;
    self.author = author;
    self.creation = creation;
    
    return self;
}

@end
