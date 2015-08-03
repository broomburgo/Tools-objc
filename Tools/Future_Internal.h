#import "Future.h"

@interface Future ()

- (void)succeedWith:(id __nonnull)value;
- (void)failWith:(id __nonnull)error;

@end
