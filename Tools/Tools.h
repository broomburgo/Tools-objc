#import <Foundation/Foundation.h>

#import "Categories.h"
#import "Queue.h"
#import "Optional.h"
#import "Either.h"
#import "Future.h"
#import "Match.h"

#define Guard(condition,returnClosure) if ((condition) == NO) returnClosure
#define GuardVoid(condition) if ((condition) == NO) { return; }

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, RandomStringType)
{
    RandomStringTypeRegular = 0,
    RandomStringTypeDigitsOnly
};

@interface Tools : NSObject

//MARK: - randomization utilities

+ (NSString*)randomStringWithType:(RandomStringType)randomStringType
                           length:(NSUInteger)length;
+ (NSString*)randomStringWithLength:(NSUInteger)length;
+ (NSString*)randomString;
+ (NSString*)randomStringDigitsOnlyWithLength:(NSUInteger)length;
+ (NSString*)randomStringDigitsOnly;
+ (float)randomFloatBetweenZeroAndOne;

//MARK: - JSON validation

+ (NSArray*)JSONValidatedArray:(NSArray*)array;
+ (NSDictionary*)JSONValidatedDictionary:(NSDictionary*)dictionary;

@end

NS_ASSUME_NONNULL_END
