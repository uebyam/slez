//
//  IdeaHead.h
//  SLEZ
//
//  Created by rey on 18/9/22.
//

#ifndef IdeaHead_h
#define IdeaHead_h

#import <FirebaseCore/FirebaseCore.h>
#import <FirebaseFirestore/FirebaseFirestore.h>

NS_ASSUME_NONNULL_BEGIN

@interface IdeaReply : NSObject

@property NSString* info;
@property NSString* author;
@property NSDate* creation;

- (instancetype)initWithInfo:(NSString*)info author:(NSString*)author creation:(NSDate*)creation;

@end

@interface IdeaComment: NSObject

@property NSString* info;
@property NSString* author;
@property NSDate* creation;
@property FIRCollectionReference* replies;

- (instancetype)initWithInfo:(NSString*)info author:(NSString*)author creation:(NSDate*)creation replies:(FIRCollectionReference*)replies;

@end

@interface Idea : NSObject

@property NSString* title;
@property NSString* info;
@property NSString* author;
@property NSDate* creation;
@property FIRCollectionReference* comments;
@property NSInteger votes;
@property NSInteger userVote;

- (instancetype)initWithTitle:(NSString*)title info:(NSString*)info author:(NSString*)author creation:(NSDate*)creation comments:(FIRCollectionReference*)comments votes:(NSInteger)votes userVote:(NSInteger)userVote;

@end

NS_ASSUME_NONNULL_END

#endif /* IdeaHead_h */
