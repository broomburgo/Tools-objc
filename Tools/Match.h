#import <Foundation/Foundation.h>

@interface Match : NSObject

+ (Match* __nonnull):(id __nonnull)value;

- (Match* __nonnull)with:(BOOL(^ __nonnull)(id __nonnull))withBlock give:(id __nullable(^ __nonnull)(id __nonnull))giveBlock;
- (id __nonnull)otherwise:(id __nullable(^ __nonnull)())otherwiseBlock;

@end
