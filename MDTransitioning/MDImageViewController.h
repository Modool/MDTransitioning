// YRImageViewController.h
//  MDTransitioning
//
//  Created by Jave on 2017/7/26.
//  Copyright © 2017年 markejave. All rights reserved.
//

#import <MDTransitioning/MDTransitioning.h>

// Simple full screen image viewer.
//
// Allows the user to view an image in full screen and double tap to zoom it.
// The view controller can be dismissed with a single tap.
@interface MDImageViewController : UIViewController<MDImageContainerViewControllerDelegate>

// The background view.
@property (nonatomic, strong, readonly) IBOutlet UIView *backgroundView;

// The scroll view used for zooming.
@property (nonatomic, strong, readonly) IBOutlet UIScrollView *scrollView;

// The image view that displays the image.
@property (nonatomic, strong, readonly) IBOutlet UIImageView *imageView;

// The image that will be shown.
@property (nonatomic, strong, readonly) UIImage *image;

// The imageURL that will be downloaded and shown.
@property (nonatomic, copy, readonly) NSURL *imageURL;

// Initializes the receiver with the specified image.
- (id)initWithImage:(UIImage *)image;

// Initializes the receiver with the specified image URL and placeholder.
- (id)initWithImageURL:(NSURL *)imageURL placeholderImage:(UIImage *)placeholderImage;

@end
