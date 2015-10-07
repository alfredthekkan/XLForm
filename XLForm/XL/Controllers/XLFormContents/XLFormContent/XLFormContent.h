//
//  XLFormContent.h
//  Pods
//
//  Created by vlad gorbenko on 10/7/15.
//
//

#import <Foundation/Foundation.h>

#import "XLFormRowNavigationDirections.h"

#import "XLFormRowNavigationAccessoryViewProtocol.h"

@protocol XLCollectionViewProtocol;
@protocol XLFormDescriptorCell;

@class XLFormDescriptor;
@class XLFormRowDescriptor;

@interface XLFormContent : NSObject

@property (nonatomic, weak) XLFormDescriptor *formDescriptor;
@property (nonatomic, weak) UIScrollView<XLCollectionViewProtocol> *formView;
@property (nonatomic) UIView<XLFormRowNavigationAccessoryViewProtocol> *navigationAccessoryView;

- (instancetype)initWithView:(UIView *)view;

- (void)navigateToDirection:(XLFormRowNavigationDirection)direction;

-(void)didSelectFormRow:(XLFormRowDescriptor *)formRow;
-(void)deselectFormRow:(XLFormRowDescriptor *)formRow;
-(void)reloadFormRow:(XLFormRowDescriptor *)formRow;
-(id<XLFormDescriptorCell>)updateFormRow:(XLFormRowDescriptor *)formRow;

-(UIView *)inputAccessoryViewForRowDescriptor:(XLFormRowDescriptor *)rowDescriptor;

-(void)ensureRowIsVisible:(XLFormRowDescriptor *)inlineRowDescriptor;

@end
