//
//  XLFormPickerCell.m
//  XLForm ( https://github.com/xmartlabs/XLForm )
//
//  Copyright (c) 2015 Xmartlabs ( http://xmartlabs.com )
//
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "UIView+XLFormAdditions.h"
#import "XLFormPickerCell.h"

@interface XLFormPickerCell() <UIPickerViewDelegate, UIPickerViewDataSource>

@end

@implementation XLFormPickerCell

@synthesize pickerView = _pickerView;
@synthesize inlineRowDescriptor = _inlineRowDescriptor;

-(BOOL)formDescriptorCellCanBecomeFirstResponder
{
    return (!self.rowDescriptor.isDisabled && (self.inlineRowDescriptor == nil));
}

-(BOOL)formDescriptorCellBecomeFirstResponder
{
    return [self becomeFirstResponder];
}


-(BOOL)canResignFirstResponder
{
    return YES;
}

-(BOOL)canBecomeFirstResponder
{
    return [self formDescriptorCellCanBecomeFirstResponder];
}

#pragma mark - Properties

-(UIPickerView *)pickerView
{
    if (_pickerView) return _pickerView;
    _pickerView = [UIPickerView autolayoutView];
    _pickerView.delegate = self;
    _pickerView.dataSource = self;
    return _pickerView;
}

#pragma mark - XLFormDescriptorCell

-(void)configure
{
    [super configure];
    [self.contentView addSubview:self.pickerView];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.pickerView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[pickerView]-0-|" options:0 metrics:0 views:@{@"pickerView" : self.pickerView}]];
}

-(void)update
{
    [super update];
    BOOL isDisable = self.rowDescriptor.isDisabled;
    self.userInteractionEnabled = !isDisable;
    self.contentView.alpha = isDisable ? 0.5 : 1.0;
    [self.pickerView selectRow:[self selectedIndex] inComponent:0 animated:NO];
    [self.pickerView reloadAllComponents];
    
}

+(CGFloat)formDescriptorCellHeightForRowDescriptor:(XLFormRowDescriptor *)rowDescriptor
{
    return 216.0f;
}

#pragma mark - UIPickerViewDelegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (self.inlineRowDescriptor){
        id value = [self.inlineRowDescriptor.selectorOptions objectAtIndex:row];
        return [self.inlineRowDescriptor formatValue:value];
    } else {
        id value = [self.rowDescriptor.selectorOptions objectAtIndex:row];
        return [self.rowDescriptor formatValue:value];
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    id value = [self.inlineRowDescriptor.selectorOptions objectAtIndex:row];
    if([value respondsToSelector:@selector(formValue)]) {
        value = [value formValue];
    }
    if (self.inlineRowDescriptor){
        self.inlineRowDescriptor.value = value;
        [self.formViewController updateFormRow:self.inlineRowDescriptor];
    }
    else {
        [self becomeFirstResponder];
        self.rowDescriptor.value = value;
    }
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (self.inlineRowDescriptor){
        return self.inlineRowDescriptor.selectorOptions.count;
    }
    return self.rowDescriptor.selectorOptions.count;
}

#pragma mark - helpers

-(NSInteger)selectedIndex {
    XLFormRowDescriptor * formRow = self.inlineRowDescriptor ?: self.rowDescriptor;
    NSInteger index = [formRow.selectorOptions indexOfObject:formRow.value];
    return index != NSNotFound ? index : -1;
}

@end
