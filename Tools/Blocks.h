
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class Optional;

@interface Block : NSObject

#pragma mark - flatMap
+ (Optional*(^)(NSDictionary*))optionalForKey:(NSString*)key as:(Class)asClass;
+ (Optional*(^)(NSString*))stringToURL;
+ (Optional*(^)(id))toValueForKeyInDict:(NSDictionary*)dictionary;

#pragma mark - map
+ (id(^)(id))identity;
+ (NSNumber*(^)(id))toIsEqualTo:(id)toObject;
+ (NSNumber*(^)(NSNumber*))toConditionWith:(NSNumber*)otherCondition;
+ (NSString*(^)(NSString*))toStringRemovingWhitespace;
+ (NSNumber*(^)(NSString*))toStringIsNotEmpty;
+ (NSNumber*(^)(id))toIsContainedIn:(NSArray*)array;
+ (NSString*(^)(id))toStringWithFormat:(NSString*)format;
+ (NSArray*(^)(NSArray*))toMappedArray:(id(^)(id))mapBlock;

#pragma mark - filter
+ (BOOL(^)(NSString*))stringIsNotEmpty;
+ (BOOL(^)(id))isKindOfClass:(Class)asClass;
+ (BOOL(^)(id))isEqualTo:(id)otherObject;
+ (BOOL(^)(id))isContainedIn:(NSArray*)possibleObjects;

#pragma mark - fixed
+ (id(^)())toValue:(id)value;
+ (void(^)(id))ignored;

@end

NS_ASSUME_NONNULL_END
