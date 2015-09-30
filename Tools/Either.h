#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, EitherType)
{
  EitherTypeLeft,
  EitherTypeRight
};

@interface Either : NSObject

+ (Either*)leftWith:(id)left;
+ (Either*)rightWith:(id)right;

- (Either*)map:(id(^)(id))mapBlock;
- (Either*)flatMap:(Either*(^)(id))flatMapBlock;

- (id)ifLeft:(id(^)(id))leftBlock
     ifRight:(id(^)(id))rightBlock;
- (id)getOrElse:(id(^)(void))lazyElse;

@end

NS_ASSUME_NONNULL_END
