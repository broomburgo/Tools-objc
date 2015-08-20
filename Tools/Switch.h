#import <Foundation/Foundation.h>

@interface Switch : NSObject

@property (nonatomic, readonly) id __nullable returnedValue;

+ (Switch* __nonnull)value:(id __nonnull)value;

- (Switch* __nonnull)inCase:(BOOL)inCase :(id __nullable(^ __nonnull)(void))returnBlock;
- (Switch* __nonnull)otherwise:(id __nullable(^ __nonnull)(void))returnBlock;

@end
