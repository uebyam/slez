//
//  head.h
//  SLEZ
//
//  Created by rey on 10/9/22.
//

#ifndef head_h
#define head_h

#import <Firebase.h>
#import <GoogleSignIn/GoogleSignIn.h>

typedef enum : NSUInteger {
    kAppRoleStudent,
    kAppRolePsb,
    kAppRoleAce,
    kAppRoleSc,
    kAppRoleBlueHouse,
    kAppRoleRedHouse,
    kAppRoleBlackHouse,
    kAppRoleYellowHouse,
    kAppRoleGreenHouse,
    kAppRoleTeacher,
    kAppRoleAdmin,
} AppRole;

typedef enum : NSUInteger {
    kAppRoleMaskStudent = 1,
    kAppRoleMaskPsb = 2,
    kAppRoleMaskAce = 4,
    kAppRoleMaskSc = 8,
    kAppRoleMaskBlueHouse = 16,
    kAppRoleMaskRedHouse = 32,
    kAppRoleMaskBlackHouse = 64,
    kAppRoleMaskYellowHouse = 128,
    kAppRoleMaskGreenHouse = 256,
    kAppRoleMaskTeacher = 512,
    kAppRoleMaskAdmin = 1024,
} AppRoleMask;

typedef enum : NSUInteger {
    kAppLevelMaskSec1 = 1,
    kAppLevelMaskSec2 = 2,
    kAppLevelMaskSec3 = 4,
    kAppLevelMaskSec4 = 8,
} AppLevelMask;

extern enum AppRole currentRole;
extern FIRUser* currentUser;
extern FIRAuth* defaultAuth;
extern FIRFirestore* defaultFirestore;


#endif /* head_h */
