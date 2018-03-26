//
//  Constant.h
//  Skeuomo
//
//  Created by Deepak iOS on 15/09/17.
//  Copyright © 2017 Anveshan It Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Constant : NSObject

#define KSCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define KSCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)

//local
//#define kSkeuomoMainURL @"http://192.168.0.100/skeuomo/api/"
//#define kSkeuomoImageURL @"http://192.168.0.100/skeuomo/"

//live
#define kSkeuomoMainURL @"http://demo2server.in/sites/laravelapp/skeuomo/api/"
#define kSkeuomoImageURL @"http://demo2server.in/sites/laravelapp/skeuomo/"

#define kSkeuomoGoogleApi @"AIzaSyDqKmENwRhT5J3rDJBtVhbROX6XCcUWWLw"



//Notification
#define kSkeuomoUpdateEventAddress @"UpdateEventAddress"


#define kUserDefault [NSUserDefaults standardUserDefaults]

//// Login Screen Alert

#define kUsernameRequiredText @"Username is required"
#define kPasswordRequiredText @"Password is required"


//// Register Screen Alert

#define kFirstnameRequiredText @"First Name is required"
#define kLastnameRequiredText @"Last Name is required"
#define kEmailRequiredText @"Email is required"
#define kEmailVaildText @"Email is not vaild"
#define kCityRequiredText @"City is required"
#define kStateRequiredText @"State is required"
#define kCountryRequiredText @"Country is required"
#define kPasswordLengthText @"Password must be greater then 6 characters."





//Edit profile
#define kAllRequiredFieldFill @"Please fill all required field."
#define kGenderRequiredText @"Gender is required"
#define kDOBRequiredText @"DOB is required"
#define kMoblieRequiredText @"Mobile number is required"
#define kMoblieLimitText @"Mobile number is required 10 digits"
#define kPostelCodeRequiredText @"Postel code is required"
#define kAdressRequiredText @"Address is required"

//change password
#define kConfirmPasswordRequiredText @"Confirm Password is required"
#define kPasswordMatchRequiredText @"Password should be same."
#define kOldPasswordRequiredText @"Old Password is required."
#define kNewPasswordRequiredText @"New Password is required."

@end
