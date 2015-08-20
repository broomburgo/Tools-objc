#import <Foundation/Foundation.h>

#pragma mark - Basic Definitions

typedef NS_ENUM(NSInteger, OptionalType) {
    OptionalTypeNone,
    OptionalTypeSome
};

@class Result;

@interface Optional : NSObject

@property (nonatomic, readonly) OptionalType type;
@property (nonatomic, readonly) id __nullable value;

- (id __nonnull)valueDefaultedTo:(id __nonnull(^ __nonnull)(void))lazyDefaultValue;

+ (Optional* __nonnull)with:(id __nullable)value;
+ (Optional* __nonnull)with:(id __nullable)value as:(Class __nonnull)requiredClass;
+ (Optional* __nonnull)with:(id __nullable)value when:(BOOL(^ __nonnull)(id __nonnull value))ifBlock;

- (Optional* __nonnull)filter:(BOOL(^ __nonnull)(id __nonnull))filterBlock;
- (Optional* __nonnull)map:(id __nonnull(^ __nonnull)(id __nonnull))mapBlock;
- (Optional* __nonnull)flatMap:(Optional* __nonnull (^ __nonnull)(id __nonnull))flatMapBlock;

- (Result* __nonnull)resultWithError:(id __nonnull)error;
- (void)applyIfPossible:(void(^ __nonnull)(id __nonnull))applyBlock;

@end

typedef id __nonnull(^MapOptionalBlock)(id __nonnull);
typedef Optional* __nonnull(^FlatMapOptionalBlock)(id __nonnull);

@interface NSDictionary (Optional)

- (Optional* __nonnull)optionalForKey:(__nonnull id)key as:(Class __nonnull)requiredClass;

@end