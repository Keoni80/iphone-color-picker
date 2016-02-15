# Instructions #

1. Add the following files into your project

```
    ColorPickerViewController.xib
    UI Parts/
       bar_select.png
       colormap.png
       crosshair.png
    Classes/
       ColorPickerViewController.h
       ColorPickerViewController.m
       ColorPickerView.h
       ColorPickerView.m
       Constants.h
       GradientView.h
       GradientView.m
       UIColor-Expanded.h
       UIColor-Expanded.m
       UIColor-HSVAdditions.h
       UIColor-HSVAdditions.m
       ColorSwatchView.m
       ColorSwatchView.h
```

2. Now you can use the ColorPickerViewController

See the file [StandinViewController.m](http://code.google.com/p/iphone-color-picker/source/browse/trunk/StandinViewController.m) for example usage.

The gist of its use:

```
-(IBAction) selectColor:(id)sender {
    // Make a new ColorPickerViewController with the interface defined in the referenced nib:
    ColorPickerViewController *colorPickerViewController = 
        [[ColorPickerViewController alloc] initWithNibName:@"ColorPickerViewController" bundle:nil];

    // The ColorPickerViewController needs a delegate to send the results back to.
    // Here, we'll use self, and implement (colorPickerViewController: didSelectColor:) below.
    colorPickerViewController.delegate = self;
    
    // The defaults key helps you keep track of the color we're supposed to be selecting
    colorPickerViewController.defaultsKey = @"BackgroundColor";
    
    // Slides the color picker view in place.
    [self presentModalViewController:colorPickerViewController animated:YES];
    [colorPickerViewController release];
}

// Delegate method handling the result
- (void)colorPickerViewController:(ColorPickerViewController *)colorPicker didSelectColor:(UIColor *)color {
    
    // We're going to save the color into the user preferences, so we need to pack it into an NSData Object.
    NSData *colorData = [NSKeyedArchiver archivedDataWithRootObject:color];
    [[NSUserDefaults standardUserDefaults] setObject:colorData forKey:colorPicker.defaultsKey];
    
    // If you just want to use the color right away, go ahead and use the passed UIColor* parameter
    if ([colorPicker.defaultsKey isEqualToString:@"BackgroundColor"])
        colorSwatch.backgroundColor = color;
        
    [colorPicker dismissModalViewControllerAnimated:YES];
}
```



## Defaults Configuration ##

It is possible to store and recall the set color value automatically. This behaviour is controlled by whether `IPHONE_COLOR_PICKER_SAVE_DEFAULT` is defined to the preprocessor

`#ifdef IPHONE_COLOR_PICKER_SAVE_DEFAULT`
  * The color is stored in the app defaults and recalled on next program start
  * Identifier key is the string stored in `defaultsKey`

`#undef IPHONE_COLOR_PICKER_SAVE_DEFAULT`
  * The initial color must be assigned after object construction
  * No app defaults are accessed
  * Member Variable is: `defaultsColor`