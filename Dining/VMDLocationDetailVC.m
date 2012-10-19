//
//  VMDLocationDetailVC.m
//  Dining
//
//  Created by Scott Andrus on 9/22/12.
//  Copyright (c) 2012 VandyMobile. All rights reserved.
//

#import "VMDLocationDetailVC.h"
#import "UIView+Frame.h"

#import <QuartzCore/QuartzCore.h>

@interface VMDLocationDetailVC ()


@end

@implementation VMDLocationDetailVC

@synthesize location = _location;

// Weekdays type
typedef enum weekdays
{
    Sunday = 1,
    Monday,
    Tuesday,
    Wednesday,
    Thursday,
    Friday,
    Saturday
} Weekday;

//meals type
// Weekdays type
typedef enum meals
{
    Breakfast = 1,
    Lunch,
    Dinner
    
} Meal;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - View Controller lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self customizeUI];
    [self downloadPhoto];
}

- (void)viewDidAppear:(BOOL)animated {
    [self.dateScrollView setContentOffset:CGPointMake(self.dateScrollView.width * 3, 0) animated:YES];
    
    [self.mealScrollView setContentOffset:CGPointMake(self.mealScrollView.width, 0) animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setNameLabel:nil];
    [self setCoverImageView:nil];
    [self setDateScrollView:nil];
    [self setDayLabel:nil];
    [self setDateLabel:nil];
    [self setHoursLabel:nil];
    [self setTitleOverlayView:nil];
    [self setTypeLabel:nil];
    [self setDateLeftButton:nil];
    [self setDateRightButton:nil];
    [self setMealScrollView:nil];
    [self setMealLabel:nil];
    [self setMealRightButton:nil];
    [self setMealLeftBurron:nil];

    [super viewDidUnload];
}

#pragma mark - Utility methods

// Customizes the UI, typically called on viewDidLoad
- (void)customizeUI {
    
    // Modify the name label
    self.nameLabel.text = self.location.name;
    self.nameLabel.size = [self.nameLabel.text sizeWithFont:self.nameLabel.font constrainedToSize:CGSizeMake(200, self.nameLabel.height)];
    
    // Width calculations based on Interface Builder dimensions
    if (self.nameLabel.width > 111) self.titleOverlayView.width = self.nameLabel.width + 15;
    else self.titleOverlayView.width = 125;
    
    // Add some borders and round some corners (QuartzCore)
    self.titleOverlayView.layer.cornerRadius = 10;
    self.dateScrollView.layer.borderColor = [[UIColor blackColor] CGColor];
    self.dateScrollView.layer.borderWidth = .5;
    self.mealScrollView.layer.borderColor = [[UIColor blackColor] CGColor];
    self.mealScrollView.layer.borderWidth = .5;
    
    // Format photo imageview
    self.coverImageView.clipsToBounds = YES;
    self.coverImageView.layer.borderColor = [[UIColor blackColor] CGColor];
    self.coverImageView.layer.borderWidth = .5;
    
    // Set up the date scroll view
    [self setupDateScrollView];
    
    // Set up the meal scroll view
    [self setupMealScrollView];
}

// Sets up the date scrollview for the current day of the week and date
- (void)setupDateScrollView {
    
    
    // Set the initial content size to be 7 times as wide for 7 days
    [self.dateScrollView setContentSize:CGSizeMake(self.dateScrollView.width * 7, self.dateScrollView.height)];
    
    // Grab the current date, convert it to weekday components
    NSDate *now = [NSDate date];
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *weekdayComponents =
    [gregorian components:(NSHourCalendarUnit | NSWeekdayCalendarUnit | NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit) fromDate:now];
    
    NSInteger weekday = [weekdayComponents weekday];
    
    //    NSInteger hour = [weekdayComponents hour];
    //    NSInteger day = [weekdayComponents day];
    //    NSInteger month = [weekdayComponents month];
    //    NSInteger year = [weekdayComponents year];
    
    // Format the date to a shortened mode
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM-dd-yy"];
    
    // Create some label pointers to be used in creating the weekday labels
    UILabel *aDayLabel;
    UILabel *aDateLabel;
    UILabel *anHoursLabel;
    
    // From -3 (three days ago) to 3 (three days from now)
    for (int i = -3; i < 4; ++i) {
        
        // Create day label
        aDayLabel = [[UILabel alloc] init];
        [self.dateScrollView addSubview:aDayLabel];
        
        // Set the frame of the day label to i + 3
        [aDayLabel setFrame:CGRectMake(self.dayLabel.left + self.dateScrollView.width * (i + 3), self.dayLabel.top, self.dayLabel.width, self.dayLabel.height)];
        
        // Other properties of the day label
        aDayLabel.textColor = [UIColor darkTextColor];
        aDayLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:20.0];
        aDayLabel.backgroundColor = [UIColor clearColor];
        aDayLabel.textAlignment = UITextAlignmentCenter;
        
        // Get the offset for the weekday
        int aWeekday = i + weekday;
        if (aWeekday < 1) {
            aWeekday += 7;
        } else if (aWeekday > 7) {
            aWeekday -= 7;
        }
        
        // Set the label's text based on the offset
        switch (aWeekday) {
            case Sunday:
                aDayLabel.text = @"Sunday";
                break;
            case Monday:
                aDayLabel.text = @"Monday";
                break;
            case Tuesday:
                aDayLabel.text = @"Tuesday";
                break;
            case Wednesday:
                aDayLabel.text = @"Wednesday";
                break;
            case Thursday:
                aDayLabel.text = @"Thursday";
                break;
            case Friday:
                aDayLabel.text = @"Friday";
                break;
            case Saturday:
                aDayLabel.text = @"Saturday";
                break;
                
            default:
                break;
        }
        
        if (i == 0) {
            aDayLabel.text = [NSString stringWithFormat:@"%@ (Today)", aDayLabel.text];
        }
        
        // Create date labels
        aDateLabel = [[UILabel alloc] init];
        [self.dateScrollView addSubview:aDateLabel];
        [aDateLabel setFrame:CGRectMake(self.dateLabel.left + self.dateScrollView.width * (i + 3), self.dateLabel.top, self.dateLabel.width, self.dateLabel.height)];
        
        // Date label properties
        aDateLabel.textColor = [UIColor darkTextColor];
        aDateLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:14.0];
        aDateLabel.backgroundColor = [UIColor clearColor];
        aDateLabel.textAlignment = UITextAlignmentCenter;
        
        // Set the text
        aDateLabel.text = [formatter stringFromDate:[NSDate dateWithTimeIntervalSinceNow:i * 24 * 60 * 60]];
        
        // Create hours labels
        anHoursLabel = [[UILabel alloc] init];
        [self.dateScrollView addSubview:anHoursLabel];
        [anHoursLabel setFrame:CGRectMake(self.hoursLabel.left + self.dateScrollView.width * (i + 3), self.hoursLabel.top, self.hoursLabel.width, self.hoursLabel.height)];
        
        // Hours label properties
        anHoursLabel.textColor = [UIColor darkGrayColor];
        anHoursLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:14.0];
        anHoursLabel.backgroundColor = [UIColor clearColor];
        anHoursLabel.textAlignment = UITextAlignmentCenter;
        
        // TODO: Get the hours from the location object
        anHoursLabel.text = @"8 AM - 9 PM";
    }
    
    // Keep track of the currently selected weekday
    self.currentlySelectedWeekday = weekday;
}

- (void)setupMealScrollView {
    
    // Set the initial content size to be 3 times as wide for 3 meal periods
    [self.mealScrollView setContentSize:CGSizeMake(self.mealScrollView.width * 3, self.mealScrollView.height)];
    
    // Grab the current date, convert it to weekday components
    NSDate *now = [NSDate date];
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *weekdayComponents =
    [gregorian components:(NSHourCalendarUnit | NSWeekdayCalendarUnit | NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit) fromDate:now];
    
    //NSInteger weekday = [weekdayComponents weekday];
    
    NSInteger hour = [weekdayComponents hour];
    //   NSInteger day = [weekdayComponents day];
    //    NSInteger month = [weekdayComponents month];
    //    NSInteger year = [weekdayComponents year];
    
    // Format the date to a shortened mode
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM-dd-yy"];
    
    // Create some label pointers to be used in creating the weekday labels
    //UILabel *aDayLabel;
    //UILabel *aDateLabel;
    //UILabel *anHoursLabel;
    UILabel *aMealLabel;
    
    //convert hours to meal period
    int mealTime = 1;
    if (hour > 11 && hour < 17) {
        mealTime = 2;
    } else if (hour > 17) {
        mealTime = 3;
    }
    
    // From -1 (Last period) to 1 (next period)
    for (int i = -1; i < 2; ++i) {
        
        // Create meal label
        aMealLabel = [[UILabel alloc] init];
        [self.mealScrollView addSubview:aMealLabel];
        
        // Set the frame of the meal label to i + 1
        [aMealLabel setFrame:CGRectMake(self.mealLabel.left + self.mealScrollView.width * (i + 1), self.mealLabel.top, self.mealLabel.width, self.mealLabel.height)];
        
        // Other properties of the day label
        aMealLabel.textColor = [UIColor darkTextColor];
        aMealLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:20.0];
        aMealLabel.backgroundColor = [UIColor clearColor];
        aMealLabel.textAlignment = UITextAlignmentCenter;
        //NSString *hrStr = [NSString stringWithFormat:@"%d", hour];
        //_testHour.text = hrStr;
        
        int aMealPeriod = i + 2;
        /*if (aMealPeriod < 1) {
            mealTime += 3;
        } else if (hour > 3) {
            mealTime -= 3;
        }*/
        
        // Set the label's text based on the offset
        switch (aMealPeriod) {
            case Breakfast:
                aMealLabel.text = @"Breakfast";
                break;
            case Lunch:
                aMealLabel.text = @"Lunch";
                break;
            case Dinner:
                aMealLabel.text = @"Dinner";
                break;
            
            default:
                break;
        }
        
        if (i == 0) {
            aMealLabel.text = [NSString stringWithFormat:@"%@ (Now)", aMealLabel.text];
        }
        
        /*// Create date labels
        aDateLabel = [[UILabel alloc] init];
        [self.dateScrollView addSubview:aDateLabel];
        [aDateLabel setFrame:CGRectMake(self.dateLabel.left + self.dateScrollView.width * (i + 3), self.dateLabel.top, self.dateLabel.width, self.dateLabel.height)];
        
        // Date label properties
        aDateLabel.textColor = [UIColor darkTextColor];
        aDateLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:14.0];
        aDateLabel.backgroundColor = [UIColor clearColor];
        aDateLabel.textAlignment = UITextAlignmentCenter;
        
        // Set the text
        aDateLabel.text = [formatter stringFromDate:[NSDate dateWithTimeIntervalSinceNow:i * 24 * 60 * 60]];
        
        // Create hours labels
        anHoursLabel = [[UILabel alloc] init];
        [self.dateScrollView addSubview:anHoursLabel];
        [anHoursLabel setFrame:CGRectMake(self.hoursLabel.left + self.dateScrollView.width * (i + 3), self.hoursLabel.top, self.hoursLabel.width, self.hoursLabel.height)];
        
        // Hours label properties
        anHoursLabel.textColor = [UIColor darkGrayColor];
        anHoursLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:14.0];
        anHoursLabel.backgroundColor = [UIColor clearColor];
        anHoursLabel.textAlignment = UITextAlignmentCenter;
        
        // TODO: Get the hours from the location object
        anHoursLabel.text = @"8 AM - 9 PM";*/
    }
    
    self.currentlySelectedMealPeriod = mealTime;
    
}

- (void)downloadPhoto {
    // Download photo
    if (![self.location.name isEqualToString:@"Featheringill Hall"]) {
        UIActivityIndicatorView *loading = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [loading startAnimating];
        UIBarButtonItem * temp = self.navigationItem.rightBarButtonItem;
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:loading];
        
        dispatch_queue_t downloadQueue = dispatch_queue_create("image donwloader", NULL);
        dispatch_async(downloadQueue, ^{
            
            // TODO: Add a different image for each location
            NSData *imgUrl = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://lh6.googleusercontent.com/-aqq7PmycegM/TrldNljr17I/AAAAAAAAAB4/i36AmfII0bI/s1024/4840887935_697d9067a0_b.jpg"]];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.coverImageView setImage:[UIImage imageWithData:imgUrl]];
                [loading stopAnimating];
                self.navigationItem.rightBarButtonItem = temp;
            });
        });
        dispatch_release(downloadQueue);
    }
    else {
        [self.coverImageView setImage:[UIImage imageNamed:@"Featheringill.jpeg"]];
    }
}

#pragma mark - UIScrollView delegate

- (void)scrollViewDidScroll:(UIScrollView *)sender {
    // Update the page when more than 50% of the previous/next page is visible
    CGFloat pageWidth = self.dateScrollView.width;
    int page = floor((self.dateScrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.currentlySelectedWeekday = page;
    
    
}

/*- (void)scrollViewDidScroll:(UIScrollView *)sender {
    // Update the page when more than 50% of the previous/next page is visible
    CGFloat pageWidth = self.mealScrollView.width;
    int page = floor((self.mealScrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.currentlySelectedMealPeriod = page;
}*/

#pragma mark - IBActions

- (IBAction)dateRightPressed {
    CGFloat pageWidth = self.dateScrollView.width;
    
    // TODO: Make this work with the currentlySelectedWeekday property
    int page = ((self.dateScrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    
    [self.dateScrollView setContentOffset:CGPointMake(self.dateScrollView.width * MIN((page + 1), 6), 0) animated:YES];
}

- (IBAction)dateLeftPressed {
    CGFloat pageWidth = self.dateScrollView.width;
    
    // TODO: Make this work with the currentlySelectedWeekday property
    int page = ((self.dateScrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    
    [self.dateScrollView setContentOffset:CGPointMake(self.dateScrollView.width * MAX((page - 1), 0), 0) animated:YES];
}

- (IBAction)mealRightPressed {
    CGFloat pageWidth = self.mealScrollView.width;
    
    // TODO: Make this work with the currentlySelectedWeekday property
    int page = ((self.mealScrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    
    [self.mealScrollView setContentOffset:CGPointMake(self.mealScrollView.width * MIN((page + 1), 2), 0) animated:YES];
}

- (IBAction)mealLeftPressed {
    CGFloat pageWidth = self.mealScrollView.width;
    
    // TODO: Make this work with the currentlySelectedWeekday property
    int page = ((self.mealScrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    
    [self.mealScrollView setContentOffset:CGPointMake(self.mealScrollView.width * MAX((page - 1), 0), 0) animated:YES];
}



@end
