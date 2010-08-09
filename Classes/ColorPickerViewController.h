//
//  ColorPickerViewController.h
//  ColorPicker
//
//  Created by Gilly Dekel on 23/3/09.
//  Extended by Fabián Cañas August 2010.
//  Copyright 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ColorPickerViewController;

@protocol ColorPickerViewControllerDelegate <NSObject>

- (void)colorPickerViewController:(ColorPickerViewController *)colorPicker didSelectColor:(UIColor *)color;

@end

@interface ColorPickerViewController : UIViewController {
    id<ColorPickerViewControllerDelegate> _delegate;
    NSString *defaultsKey;
    IBOutlet UIButton *chooseButton;
}

@property(nonatomic,assign)	id<ColorPickerViewControllerDelegate> delegate;
@property(readwrite,nonatomic,retain) NSString *defaultsKey;
@property(readwrite,nonatomic,retain) IBOutlet UIButton *chooseButton;

- (IBAction) chooseSelectedColor;
- (UIColor *) getSelectedColor;

@end

