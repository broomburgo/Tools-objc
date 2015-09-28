#import "Future.h"
#import "Future_Internal.h"
#import "Queue.h"
#import "Tools.h"

@interface Future ()

@property (copy, nonatomic, nullable) id get;
@property (copy, nonatomic, nullable) id error;
@property (strong, nonatomic) NSMutableArray* m_completeBlocks;

@end

@implementation Future

- (instancetype)init
{
  self = [super init];
  if (self == nil)
  {
    return nil;
  }
  _m_completeBlocks = [NSMutableArray array];
  return self;
}

- (FutureState)state
{
  if (self.get == nil && self.error == nil)
  {
    return FutureStateIncomplete;
  }
  else if (self.get != nil)
  {
    return FutureStateSucceeded;
  }
  else
  {
    return FutureStateFailed;
  }
}

- (BOOL)isComplete
{
  return self.state != FutureStateIncomplete;
}

+ (Future*)succeededWith:(id)value
{
  Future* future = [Future new];
  [future succeedWith:value];
  return future;
}

+ (Future*)failedWith:(id)error
{
  Future* future = [Future new];
  [future failWith:error];
  return future;
}

- (Future*)onComplete:(void (^)(BOOL success, id value, id  error))completeBlock
{
  switch (self.state)
  {
    case FutureStateIncomplete:
    {
      [self.m_completeBlocks addObject:[completeBlock copy]];
      break;
    }
    case FutureStateSucceeded:
    {
      completeBlock(YES,self.get,nil);
      break;
    }
    case FutureStateFailed:
    {
      completeBlock(NO,nil,self.error);
      break;
    }
  }
  return self;
}

- (Future*)onSuccess:(void (^)(id value))successBlock
{
  return [self
          onComplete:^(BOOL success, id value, id error){
            if (success)
            {
              successBlock(value);
            }
          }];
}

- (Future*)onFailure:(void (^)(id  error))failureBlock
{
  return [self
          onComplete:^(BOOL success, id value, id error){
            if (success == NO)
            {
              failureBlock(error);
            }
          }];
}

- (Future*)map:(id  (^)(id value))mapBlock
{
  Future* newFuture = [Future new];
  [self
   onSuccess:^(id value){
     [newFuture succeedWith:mapBlock(value)];
   }];
  [self
   onFailure:^(id error){
     [newFuture failWith:error];
   }];
  return newFuture;
}

- (Future*)flatMap:(Future * (^)(id value))flatMapBlock
{
  Future* newFuture = [Future new];
  [self
   onSuccess:^(id value){
     Future* mappedFuture = flatMapBlock(value);
     [mappedFuture
      onSuccess:^(id futureValue){
        [newFuture succeedWith:futureValue];
      }];
     [mappedFuture
      onFailure:^(id error){
        [newFuture failWith:error];
      }];
   }];
  [self
   onFailure:^(id error){
     [newFuture failWith:error];
   }];
  return newFuture;
}

- (void)succeedWith:(id)value
{
  [self
   completeWithSuccess:YES
   value:value
   error:nil];
}

- (void)failWith:(id )error
{
  [self
   completeWithSuccess:NO
   value:nil
   error:error];
}

- (void)completeWithSuccess:(BOOL)success value:(id)value error:(id)error
{
  GuardVoid(self.isComplete == NO)
  NSArray* completeBlocks = [NSArray arrayWithArray:self.m_completeBlocks];
  [self.m_completeBlocks removeAllObjects];
  self.get = value;
  self.error = error;
  for (CompleteBlock block in completeBlocks)
  {
    [[Queue main]
     async:^{
       block(success, value, error);
     }];
  }
}

@end
