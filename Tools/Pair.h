#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Pair : NSObject <NSCopying,NSCoding>

@property (copy, nonatomic, readonly) id<NSObject,NSCopying,NSCoding> object1;
@property (copy, nonatomic, readonly) id<NSObject,NSCopying,NSCoding> object2;

+ (instancetype):(id<NSObject,NSCopying,NSCoding>)object1 :(id<NSObject,NSCopying,NSCoding>)object2;

@end

NS_ASSUME_NONNULL_END
