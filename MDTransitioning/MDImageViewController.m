// MDImageViewController.h
//  MDTransitioning
//
//  Created by Jave on 2017/7/26.
//  Copyright © 2017年 markejave. All rights reserved.
//

#import <objc/runtime.h>
#import "MDImageViewController.h"
#import "MDImageDismissInteractionController.h"
#import "MDImageDraggingDismissInteractionController.h"

@interface MDImageViewController ()<UIScrollViewDelegate, MDPresentionInteractiveTransitioning>

@property (nonatomic, strong) IBOutlet UIView *backgroundView;

@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;

@property (nonatomic, strong) IBOutlet UIImageView *imageView;

@property (nonatomic, strong) IBOutlet UITapGestureRecognizer *singleTapGestureRecognizer;

@property (nonatomic, strong) IBOutlet UITapGestureRecognizer *doubleTapGestureRecognizer;

@property (nonatomic, strong) UIImage *image;

@property (nonatomic, copy) NSURL *imageURL;

@end

@implementation MDImageViewController

- (id)initWithImage:(UIImage *)image;{
    return [self initWithImageURL:nil placeholderImage:image];
}

- (id)initWithImageURL:(NSURL *)imageURL placeholderImage:(UIImage *)placeholderImage;{
    if (self = [super init]) {
        self.imageURL = imageURL;
        self.image = placeholderImage;
        self.modalPresentationStyle = UIModalPresentationCustom;
    }
    return self;
}

- (void)loadView{
    [super loadView];
    
    self.view.backgroundColor = [UIColor clearColor];
    self.scrollView.contentSize = self.view.bounds.size;
    
    [[self view] addSubview:[self backgroundView]];
    [[self view] addSubview:[self scrollView]];
    [[self scrollView] addSubview:[self imageView]];
    
    [[self imageView] addGestureRecognizer:[self singleTapGestureRecognizer]];
    [[self imageView] addGestureRecognizer:[self doubleTapGestureRecognizer]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.presentionInteractiveController = [MDImageDismissInteractionController interactionControllerWithViewController:self];
    self.presentionInteractiveController = [MDImageDraggingDismissInteractionController interactionControllerWithViewController:self];
    
    [[self singleTapGestureRecognizer] requireGestureRecognizerToFail:[self doubleTapGestureRecognizer]];
}

#pragma mark - accessor

- (UIView *)backgroundView{
    if (!_backgroundView) {
        _backgroundView = [[UIView alloc] initWithFrame:[[self view] bounds]];
        _backgroundView.backgroundColor = [UIColor blackColor];
    }
    return _backgroundView;
}

- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:[[self view] bounds]];
        _scrollView.delegate = self;
        _scrollView.maximumZoomScale = 2;
    }
    return _scrollView;
}

- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:[[self view] bounds]];
        _imageView.image = [self image];
        _imageView.userInteractionEnabled = YES;
        _imageView.multipleTouchEnabled = YES;
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        
        if ([self imageURL]) {
            _imageView.image = [UIImage imageWithContentsOfFile:[[self imageURL] absoluteString]];
        }
    }
    return _imageView;
}

- (UITapGestureRecognizer *)singleTapGestureRecognizer{
    if (!_singleTapGestureRecognizer) {
        _singleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
        _singleTapGestureRecognizer.numberOfTapsRequired = 1;
    }
    return _singleTapGestureRecognizer;
}

- (UITapGestureRecognizer *)doubleTapGestureRecognizer{
    if (!_doubleTapGestureRecognizer) {
        _doubleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
        _doubleTapGestureRecognizer.numberOfTapsRequired = 2;
    }
    return _doubleTapGestureRecognizer;
}

#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return [self imageView];
}

#pragma mark - MDPresentionInteractiveTransitioning

- (id<MPresentionAnimatedTransitioning>)animationForPresentionOperation:(MDPresentionAnimatedOperation)operation fromViewController:(UIViewController<MDImageZoomViewControllerDelegate> *)fromViewController toViewController:(UIViewController<MDImageZoomViewControllerDelegate> *)toViewController;{
    return [MDImageZoomAnimationController animationForPresentOperation:operation fromViewController:fromViewController toViewController:toViewController];
}

#pragma mark - actions

- (IBAction)handleSingleTap:(UITapGestureRecognizer *)tapGestureRecognizer {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)handleDoubleTap:(UITapGestureRecognizer *)tapGestureRecognizer {
    if ([[self scrollView] zoomScale] == [[self scrollView] minimumZoomScale]) {
        // Zoom in
        CGPoint center = [tapGestureRecognizer locationInView:[self scrollView]];
        CGSize size = CGSizeMake(self.scrollView.bounds.size.width / self.scrollView.maximumZoomScale,
                                 self.scrollView.bounds.size.height / self.scrollView.maximumZoomScale);
        CGRect rect = CGRectMake(center.x - (size.width / 2.0), center.y - (size.height / 2.0), size.width, size.height);
        [[self scrollView] zoomToRect:rect animated:YES];
    } else {
        // Zoom out
        [[self scrollView] zoomToRect:[[self scrollView] bounds] animated:YES];
    }
}

@end
