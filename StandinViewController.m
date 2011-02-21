//
//  StandinViewController.m
//  ColorPicker
//
//  Created by Fabián Cañas on 8/9/10.
//  Copyright 2010 Fabián Cañas. All rights reserved.
//
//    Redistribution and use in source and binary forms, with or without
//    modification, are permitted provided that the following conditions are met:
//    * Redistributions of source code must retain the above copyright
//    notice, this list of conditions and the following disclaimer.
//    * Redistributions in binary form must reproduce the above copyright
//    notice, this list of conditions and the following disclaimer in the
//    documentation and/or other materials provided with the distribution.
//    * Neither the name of the <organization> nor the
//    names of its contributors may be used to endorse or promote products
//    derived from this software without specific prior written permission.
//
//    THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
//    ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//    WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//    DISCLAIMED. IN NO EVENT SHALL FABIAN CANAS BE LIABLE FOR ANY
//    DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
//    (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
//     LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
//    ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//    (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
//    SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//

#import "StandinViewController.h"

@implementation StandinViewController

@synthesize colorSwatch, cmyColor;

-(IBAction) selectColor:(id)sender {
    ColorPickerViewController *colorPickerViewController = [[ColorPickerViewController alloc] initWithNibName:@"ColorPickerViewController" bundle:nil];
    colorPickerViewController.delegate = self;
#ifdef IPHONE_COLOR_PICKER_SAVE_DEFAULT
	if ([sender tag] == 1) { // Choose RGB Color
		colorPickerViewController.defaultsKey = @"SwatchColor";
	} else if ([sender tag] == 2) { // Choose CMY Color
		colorPickerViewController.defaultsKey = @"CMYColor";
	}
#else
    // We re-use the current value set to the background of this demonstration view
    colorPickerViewController.defaultsColor = colorSwatch.backgroundColor;
#endif
    [self presentModalViewController:colorPickerViewController animated:YES];
    [colorPickerViewController release];
}

- (void)colorPickerViewController:(ColorPickerViewController *)colorPicker didSelectColor:(UIColor *)color {
    NSLog(@"Color: %d",color);
    
#ifdef IPHONE_COLOR_PICKER_SAVE_DEFAULT
    if ([colorPicker.defaultsKey isEqualToString:@"SwatchColor"]) { // RGB Color
		NSData *colorData = [NSKeyedArchiver archivedDataWithRootObject:color];
		[[NSUserDefaults standardUserDefaults] setObject:colorData forKey:colorPicker.defaultsKey];
	} else if ([colorPicker.defaultsKey isEqualToString:@"CMYColor"]) { // CMY Color
		CGColorRef colorRef = [color CGColor];
		int numberOfComponents = CGColorGetNumberOfComponents(colorRef);
		if (numberOfComponents == 5) {
			const CGFloat *components = CGColorGetComponents(colorRef);
			[[NSUserDefaults standardUserDefaults] setObject:[NSArray arrayWithObjects:[NSNumber numberWithFloat:components[0]], [NSNumber numberWithFloat:components[1]], [NSNumber numberWithFloat:components[2]], [NSNumber numberWithFloat:0.0], [NSNumber numberWithFloat:1.0], nil] forKey:@"CMYComponents"];
		}
	}
#endif
	
	colorSwatch.backgroundColor = color;
    [colorPicker dismissModalViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
#ifdef IPHONE_COLOR_PICKER_SAVE_DEFAULT
    // Retrieve saved user default for the color swatch - Must be archived before stored as a preference
    // Retrieve data object
    NSData *colorData = [[NSUserDefaults standardUserDefaults] objectForKey:@"SwatchColor"];
    UIColor *color;
    if (colorData!=nil) {
        // If the data object is valid, unarchive the color we've stored in it.
        color = (UIColor *)[NSKeyedUnarchiver unarchiveObjectWithData:colorData];
    } else {
        // If the data's not valid, the user default wasn't set, or there was an error retrieving the default value.
        
        // This is not the Apple-sanctioned way to set up defaults, but it _is_ permissible
        // The correct way to do it would be to register 'fall-back' defaults when the app launches for the first time,
        // usually via the app delegate.
        //
        // I've done it this way to consolidate initial defaults with error-checking code.
        
        // Create a new color (gray)
        color = [UIColor grayColor];
        // Archive the color into an NSData object
        colorData = [NSKeyedArchiver archivedDataWithRootObject:color];
        // Store the NSData into the user defaults
        [[NSUserDefaults standardUserDefaults] setObject:colorData forKey:@"SwatchColor"];
    }
	
	if ([[NSUserDefaults standardUserDefaults] objectForKey:@"CMYComponents"] == nil) { // whiteColor
		[[NSUserDefaults standardUserDefaults] setObject:[NSArray arrayWithObjects:[NSNumber numberWithFloat:0.0], [NSNumber numberWithFloat:0.0], [NSNumber numberWithFloat:0.0], [NSNumber numberWithFloat:0.0], [NSNumber numberWithFloat:1.0], nil] forKey:@"CMYComponents"];
	}
	
    // Set the swatch color
    colorSwatch.backgroundColor = color;
#else
    // Set some arbitrary default color
    // Attention: This is not they way you should do it. Because everytime the ViewDidUnload
    // the color information will be lost. It's just the easy way for demonstration purposes
    colorSwatch.backgroundColor = [UIColor redColor];
#endif

}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    colorSwatch = nil;
	cmyColor = nil;
}


- (void)dealloc {
    [colorSwatch release];
	[cmyColor release];
    [super dealloc];
}


@end
