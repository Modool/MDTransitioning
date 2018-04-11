// Copyright (c) 2017 Modool. All rights reserved.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:

// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

#import <MDTransitioning/MDTransitioning.h>
#import "MDPresentedViewController.h"

@interface MDPresentedViewController ()

@end

@implementation MDPresentedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor redColor];
    
    UIButton *dismissButton = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    [dismissButton setTitle:@"dismiss" forState:UIControlStateNormal];
    [dismissButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [dismissButton addTarget:self action:@selector(didClickDismiss:) forControlEvents:UIControlEventTouchUpInside];
    
    [[self view] addSubview:dismissButton];
    
    if ([self transitioningDelegate]) {
        MDVerticalSwipDismissInteractionController *interactionController = [MDVerticalSwipDismissInteractionController interactionControllerWithViewController:self];
        interactionController.verticalTranslation = CGRectGetHeight([[self view] bounds]);
        
        self.presentionInteractionController = interactionController;
    }
}

#pragma mark - actions

- (IBAction)didClickDismiss:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
