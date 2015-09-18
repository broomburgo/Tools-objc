#import "Future.h"
#import "Future_Internal.h"
#import "Queue.h"

@interface Future ()

@property (copy, nonatomic) id __nullable get;
@property (copy, nonatomic) id __nullable error;
@property (strong, nonatomic) NSMutableArray* m_completeBlocks;

@end

@implementation Future

- (instancetype)init {
    self = [super init];
    if (self == nil) {
        return nil;
    }
    _m_completeBlocks = [NSMutableArray array];
    return self;
}

- (FutureState)state {
    if (self.get == nil && self.error == nil) {
        return FutureStateIncomplete;
    }
    else if (self.get != nil) {
        return FutureStateSucceeded;
    }
    else  {
        return FutureStateFailed;
    }
}

- (BOOL)isComplete {
    return self.state != FutureStateIncomplete;
}

+ (Future*)succeededWith:(id __nonnull)value {
    Future* future = [Future new];
    [future succeedWith:value];
    return future;
}

+ (Future*)failedWith:(id __nonnull)error {
    Future* future = [Future new];
    [future failWith:error];
    return future;
}

- (Future* __nonnull)onComplete:(void (^ __nonnull)(BOOL success, id __nullable value, id  __nullable error))completeBlock {
    switch (self.state) {
        case FutureStateIncomplete: {
            [self.m_completeBlocks addObject:[completeBlock copy]];
            break;
        }
        case FutureStateSucceeded: {
            completeBlock(YES,self.get,nil);
            break;
        }
        case FutureStateFailed: {
            completeBlock(NO,nil,self.error);
            break;
        }
    }
    return self;
}

- (Future* __nonnull)onSuccess:(void (^ __nonnull)(id __nonnull value))successBlock {
    return [self onComplete:^(BOOL success, id __nullable value, id __nullable error){
        if (success) {
            successBlock(value);
        }
    }];
}

- (Future* __nonnull)onFailure:(void (^ __nonnull)(id  __nonnull error))failureBlock {
    return [self onComplete:^(BOOL success, id __nullable value, id __nullable error){
        if (success == NO) {
            failureBlock(error);
        }
    }];
}

- (Future* __nonnull)map:(id  __nonnull (^ __nonnull)(id __nonnull value))mapBlock {
    Future* newFuture = [Future new];
    [self onSuccess:^(id __nonnull value){
        [newFuture succeedWith:mapBlock(value)];
    }];
    [self onFailure:^(id __nonnull error){
        [newFuture failWith:error];
    }];
    return newFuture;
}

- (Future* __nonnull)flatMap:(Future * __nonnull (^ __nonnull)(id __nonnull value))flatMapBlock {
    Future* newFuture = [Future new];
    [self onSuccess:^(id __nonnull value){
        Future* mappedFuture = flatMapBlock(value);
        [mappedFuture onSuccess:^(id __nonnull futureValue){
            [newFuture succeedWith:futureValue];
        }];
        [mappedFuture onFailure:^(id __nonnull error){
            [newFuture failWith:error];
        }];
    }];
    [self onFailure:^(id __nonnull error){
        [newFuture failWith:error];
    }];
    return newFuture;
}

- (void)succeedWith:(id __nonnull)value {
    [self completeWithSuccess:YES value:value error:nil];
}

- (void)failWith:(id  __nonnull)error {
    [self completeWithSuccess:NO value:nil error:error];
}

- (void)completeWithSuccess:(BOOL)success value:(id __nullable)value error:(id __nullable)error {
    if (self.isComplete) {
        return;
    }
    NSArray* completeBlocks = [NSArray arrayWithArray:self.m_completeBlocks];
    [self.m_completeBlocks removeAllObjects];
    self.get = value;
    self.error = error;
    for (CompleteBlock block in completeBlocks) {
        [[Queue main] async:^{
            block(success, value, error);
        }];
    }
}

@end
