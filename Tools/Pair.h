#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Pair : NSObject <NSCopying, NSCoding>

@property (copy, nonatomic, readonly) id<NSCopying, NSCoding> object1;
@property (copy, nonatomic, readonly) id<NSCopying, NSCoding> object2;

+ (instancetype)withObject1:(id<NSCopying, NSCoding>)object1 object2:(id<NSCopying, NSCoding>)object2;

@end

NS_ASSUME_NONNULL_END
