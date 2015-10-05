
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class Optional;

@interface Block : NSObject

#pragma mark - flatMap
+ (Optional*(^)(NSDictionary*))optionalForKey:(NSString*)key as:(Class)asClass;
+ (Optional*(^)(NSString*))stringToURL;

#pragma mark - map
+ (NSNumber*(^)(id))toIsEqualTo:(id)toObject;
+ (NSNumber*(^)(NSNumber*))toConditionWith:(NSNumber*)otherCondition;
+ (NSString*(^)(NSString*))toStringRemovingWhitespace;
+ (NSNumber*(^)(NSString*))toStringIsNotEmpty;
+ (NSNumber*(^)(id))toIsContainedIn:(NSArray*)array;
+ (NSString*(^)(id))toStringWithFormat:(NSString*)format;

#pragma mark - filter
+ (BOOL(^)(NSString*))stringIsNotEmpty;
+ (BOOL(^)(id))isKindOfClass:(Class)asClass;

@end

NS_ASSUME_NONNULL_END
