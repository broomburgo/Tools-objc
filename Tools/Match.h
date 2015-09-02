#import <Foundation/Foundation.h>

#define Case(typedValue,condition) inCase:^BOOL(typedValue){ return condition; } :^id(typedValue)
#define Otherwise(typedValue) otherwise:^id(typedValue)

@interface Match : NSObject

@property (nonatomic, readonly) id __nullable matchedValue;

+ (Match* __nonnull):(id __nonnull)value;

- (Match* __nonnull)inCase:(BOOL(^ __nonnull)(id __nonnull))inCase :(id __nullable(^ __nonnull)(id __nonnull))returnBlock;
- (Match* __nonnull)otherwise:(id __nullable(^ __nonnull)(id __nonnull))returnBlock;

@end
