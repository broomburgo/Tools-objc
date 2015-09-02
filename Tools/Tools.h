#import <Foundation/Foundation.h>

#import "Categories.h"
#import "Queue.h"
#import "Optional.h"
#import "Result.h"
#import "Future.h"
#import "Match.h"

typedef NS_ENUM(NSInteger, RandomStringType) {
    RandomStringTypeRegular = 0,
    RandomStringTypeDigitsOnly
};

@interface Tools : NSObject

///MARK: randomization utilities

+ (NSString* __nonnull)randomStringWithType:(RandomStringType)randomStringType length:(NSUInteger)length;
+ (NSString* __nonnull)randomStringWithLength:(NSUInteger)length;
+ (NSString* __nonnull)randomString;
+ (NSString* __nonnull)randomStringDigitsOnlyWithLength:(NSUInteger)length;
+ (NSString* __nonnull)randomStringDigitsOnly;
+ (float)randomFloatBetweenZeroAndOne;

///MARK: JSON validation

+ (NSArray* __nonnull)JSONValidatedArray:(NSArray* __nonnull)array;
+ (NSDictionary* __nonnull)JSONValidatedDictionary:(NSDictionary* __nonnull)dictionary;

@end
