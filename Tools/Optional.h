#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, OptionalType)
{
    OptionalTypeNone,
    OptionalTypeSome
};

@interface Zipped : NSObject

@property (nonatomic, readonly) id object1;
@property (nonatomic, readonly) id object2;

+ (Zipped*)withObject1:(id)object1
               object2:(id)object2;

@end

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

- (Optional*)zipWith:(Optional*)otherOptional; /// Optional<Zipped>

- (Either*)eitherWithError:(id)error;
- (void)applyIfPossible:(void(^)(id))applyBlock;

@end

@interface OptionalList : NSObject

- (OptionalList*)with:(Optional*)optional;
- (id _Nullable)getFirst;
- (Optional* _Nullable)getFirstOptionalSome;

@end

typedef id _Nonnull(^MapOptionalBlock)(id);
typedef Optional* _Nonnull(^FlatMapOptionalBlock)(id);

@interface NSDictionary (Optional)

- (Optional*)optionalForKey:(id)key
                         as:(Class)requiredClass;

@end

NS_ASSUME_NONNULL_END
