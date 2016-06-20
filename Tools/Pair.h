#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Pair : NSObject <NSCopying>

@property (copy, nonatomic, readonly) id<NSCopying> object1;
@property (copy, nonatomic, readonly) id<NSCopying> object2;

+ (instancetype)withObject1:(id<NSCopying>)object1 object2:(id<NSCopying>)object2;

@end

NS_ASSUME_NONNULL_END
