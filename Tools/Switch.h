#import <Foundation/Foundation.h>

#define Case(typedValue,condition) inCase:^BOOL(typedValue){ return condition; } :^id(typedValue)
#define Otherwise(typedValue) otherwise:^id(typedValue)

@interface Switch : NSObject

@property (nonatomic, readonly) id __nullable returnedValue;

+ (Switch* __nonnull)value:(id __nonnull)value;

- (Switch* __nonnull)inCase:(BOOL(^ __nonnull)(id __nonnull))inCase :(id __nullable(^ __nonnull)(id __nonnull))returnBlock;
- (Switch* __nonnull)otherwise:(id __nullable(^ __nonnull)(id __nonnull))returnBlock;

@end
