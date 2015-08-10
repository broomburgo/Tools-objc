#import <Foundation/Foundation.h>

#pragma mark - Basic Definitions

typedef NS_ENUM(NSInteger, OptionalType) {
    OptionalTypeNone,
    OptionalTypeSome
};

@interface Optional : NSObject

@property (nonatomic, readonly) OptionalType type;
@property (nonatomic, readonly) id __nullable value;

- (id __nonnull)valueDefaultedTo:(id __nonnull)defaultValue;

+ (Optional* __nonnull)with:(id __nullable)value;
- (Optional* __nonnull)mapOptional:(id __nonnull(^ __nonnull)(id __nonnull))mapBlock;
- (Optional* __nonnull)flatMapOptional:(Optional* __nonnull (^ __nonnull)(id __nonnull))flatMapBlock;

@end

typedef id __nonnull(^MapOptionalBlock)(id __nonnull);
typedef Optional* __nonnull(^FlatMapOptionalBlock)(id __nonnull);

@interface NSDictionary (Optional)

- (Optional* __nonnull)optionalForKey:(__nonnull id)key as:(Class __nonnull)requiredClass;

@end