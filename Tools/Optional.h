#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, OptionalType)
{
    OptionalTypeNone,
    OptionalTypeSome
};

@class Either;

@interface Optional : NSObject

@property (nonatomic, readonly) OptionalType type;
@property (nonatomic, readonly, nullable) id get;

- (id)getOrElse:(id(^)(void))lazyElse;

+ (Optional*)with:(id _Nullable)value;
+ (Optional*)with:(id _Nullable)value
               as:(Class)requiredClass;
+ (Optional*)with:(id _Nullable)value
             when:(BOOL(^)(id value))ifBlock;

- (Optional*)filter:(BOOL(^)(id))filterBlock;
- (Optional*)map:(id(^)(id))mapBlock;
- (Optional*)flatMap:(Optional*(^)(id))flatMapBlock;

- (Either*)eitherWithError:(id)error;
- (void)applyIfPossible:(void(^)(id))applyBlock;

@end

typedef id _Nonnull(^MapOptionalBlock)(id);
typedef Optional* _Nonnull(^FlatMapOptionalBlock)(id);

@interface NSDictionary (Optional)

- (Optional*)optionalForKey:(id)key
                         as:(Class)requiredClass;

@end

NS_ASSUME_NONNULL_END
