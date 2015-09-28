#import "Future.h"

NS_ASSUME_NONNULL_BEGIN

@interface Future ()

- (void)succeedWith:(id)value;
- (void)failWith:(id)error;

@end

NS_ASSUME_NONNULL_END
