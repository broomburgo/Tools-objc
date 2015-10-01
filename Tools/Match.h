#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Match : NSObject

+ (Match*):(id)value;

- (Match*)with:(BOOL(^)(id))withBlock
          give:(id _Nullable(^)(id))giveBlock;
- (Match*)type:(Class)type
          give:(id _Nullable(^)(id))giveBlock;

- (id)otherwise:(id _Nullable(^)())otherwiseBlock;

@end

NS_ASSUME_NONNULL_END
