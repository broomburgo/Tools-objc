#import <Foundation/Foundation.h>

#import "NSArray+Build.h"
#import "NSArray+MapReduce.h"
#import "NSArray+Optionals.h"
#import "NSDictionary+Map.h"
#import "NSDictionary+Optionals.h"
#import "NSDictionary+RequestClass.h"
#import "NSObject+Maybe.h"

#import "Queue.h"
#import "Future.h"
#import "Optional.h"
#import "Result.h"

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
