#import <Foundation/Foundation.h>

#import "Categories.h"
#import "Queue.h"
#import "Optional.h"
#import "Either.h"
#import "Future.h"
#import "Match.h"

#define Guard(condition,returnClosure) if ((condition) == NO) returnClosure
#define GuardVoid(condition) if ((condition) == NO) { return; }
#define GuardNil(condition) if ((condition) == NO) { return nil; }
#define GuardSelf(condition) if ((condition) == NO) { return self; }
#define GuardBreak(condition) if ((condition) == NO) { break; }

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, RandomStringType)
{
    RandomStringTypeRegular = 0,
    RandomStringTypeDigitsOnly
};

@interface Tools : NSObject

#pragma mark - randomization utilities

+ (NSString*)randomStringWithType:(RandomStringType)randomStringType
                           length:(NSUInteger)length;
+ (NSString*)randomStringWithLength:(NSUInteger)length;
+ (NSString*)randomString;
+ (NSString*)randomStringDigitsOnlyWithLength:(NSUInteger)length;
+ (NSString*)randomStringDigitsOnly;
+ (float)randomFloatBetweenZeroAndOne;

#pragma mark - JSON validation

+ (NSArray*)JSONValidatedArray:(NSArray*)array;
+ (NSDictionary*)JSONValidatedDictionary:(NSDictionary*)dictionary;

#pragma mark - composition blocks

+ (Optional*(^)(NSDictionary*))optionalForKey:(NSString*)key as:(Class)asClass;
+ (NSNumber*(^)(id))toIsEqualTo:(id)toObject;
+ (NSNumber*(^)(NSNumber*))conditionWith:(NSNumber*)otherCondition;
+ (NSString*(^)(NSString*))stringRemoveWhitespace;
+ (BOOL(^)(NSString*))stringIsNotEmpty;
+ (Optional*(^)(NSString*))stringToURL;
+ (NSNumber*(^)(id))toIsContainedIn:(NSArray*)array;
+ (NSString*(^)(id))stringWithFormat:(NSString*)format;

@end

NS_ASSUME_NONNULL_END
