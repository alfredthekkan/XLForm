//
//  VGConditionConfirm.m
//  Pods
//
//  Created by Vlad Gorbenko on 7/2/16.
//
//

#import "VGConditionConfirm.h"

#import "XLFormRowDescriptor.h"

#import "VGCondition+Form.h"

@implementation VGConditionConfirm

#pragma mark - Lifecycle

+ (nonnull instancetype)conditionWithTag:(nonnull NSString *)tag {
    return [[self alloc] initWithTag:tag];
}

+ (nonnull instancetype)conditionWithTag:(nonnull NSString *)tag description:(nonnull NSString *)description {
    return [[self alloc] initWithTag:tag description:description];
}

- (nonnull instancetype)initWithTag:(nonnull NSString *)tag {
    self = [super init];
    if(self) {
        _tag = tag;
    }
    return self;
}

- (nonnull instancetype)initWithTag:(nonnull NSString *)tag description:(nonnull NSString *)description {
    self = [super initWithDescription:description];
    if(self) {
        _tag = tag;
    }
    return self;
}

#pragma mark - Validation

- (BOOL)checkValue:(id)value {
    id otherValue = [self.form formRowWithTag:self.tag];
    BOOL result = value == otherValue;
    if([value isKindOfClass:[NSObject class]] && [otherValue isKindOfClass:[NSObject class]]) {
         result = result || [value isEqual:otherValue];
    }
    return result;
}

@end
