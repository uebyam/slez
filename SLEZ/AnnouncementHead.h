//
//  AnnouncementHead.h
//  SLEZ
//
//  Created by rey on 14/9/22.
//

#ifndef AnnouncementHead_h
#define AnnouncementHead_h

#import <FirebaseCore/FirebaseCore.h>
#import <FirebaseFirestore/FirebaseFirestore.h>

NS_ASSUME_NONNULL_BEGIN

@interface Announcement : NSObject

@property NSString* title;
@property NSString* info;
@property NSString* author;
@property NSDate* creation;
@property FIRCollectionReference* comments;
@property bool important;

- (instancetype)initWithTitle:(NSString*)title info:(NSString*)info creation:(NSDate*)creation author:(NSString*)author comments:(FIRCollectionReference* _Nullable)comments important:(BOOL)important;

@end

@interface Comment : NSObject

@property NSString* info;
@property NSString* author;
@property NSDate* creation;
@property FIRCollectionReference* replies;

- (instancetype)initWithInfo:(NSString*)info author:(NSString*)author creation:(NSDate*)creation replies:(FIRCollectionReference* _Nullable)replies;

@end

@interface Reply : NSObject

@property NSString* info;
@property NSString* author;
@property NSDate* creation;

- (instancetype)initWithInfo:(NSString*)info author:(NSString*)author creation:(NSDate*)creation;

@end

NS_ASSUME_NONNULL_END

#endif /* AnnouncementHead_h */
