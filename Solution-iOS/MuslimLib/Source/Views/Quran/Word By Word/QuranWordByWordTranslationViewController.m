//
//  QuranWordByWordTranslationViewController.m
//  MuslimLib
//
//  Created by Mohammad Ali Yektaie on 9/26/16.
//  Copyright © 2016 YekiSoft. All rights reserved.
//

#import "QuranWordByWordTranslationViewController.h"
#import "Utils.h"
#import "MuslimLib.h"
#import "LanguageStrings.h"
#import "Theme.h"
#import "QuranWordByWordTranslationCell.h"

#define CELL_IDENTIFIER @"cell_id_for_quran_word_by_word"

@interface QuranWordByWordTranslationViewController ()

@end

@implementation QuranWordByWordTranslationViewController

+ (QuranWordByWordTranslationViewController*)create:(QuranVerse*)verse {
    QuranWordByWordTranslationViewController* result = (QuranWordByWordTranslationViewController*)[Utils createViewControllerFromStoryboard:@"QuranWordByWordTranslationViewController"];
    
    result.verseInfo = verse;
    
    return result;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = L(@"QuranTab/ReadQuran/VerseOptions/ViewWordByWordTranslation");
    
    [[MuslimLib instance] getQuranVerseWordByWordTranslations:self.verseInfo callback:^(NSArray *translations) {
        if (translations == nil) {
            [self dismissViewControllerAnimated:YES completion:nil];
        } else {
            self.words = translations;
            
            self.tableView.delegate = self;
            self.tableView.dataSource = self;
            
            [self.tableView registerClass:[QuranWordByWordTranslationCell class] forCellReuseIdentifier:CELL_IDENTIFIER];
        }
    } controller:self];
    
    self.cmdClose.title = L(@"Close");
    
    [self.cmdClose setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                           [Utils createDefaultFont:16], NSFontAttributeName,
                                           nil]
                                 forState:UIControlStateNormal];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.words.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QuranWordByWordTranslationCell* cell = (QuranWordByWordTranslationCell*)[tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[QuranWordByWordTranslationCell alloc] initWithReuseIdentifier:CELL_IDENTIFIER];
    }
    
    VerseWordTranslation* info = [self.words objectAtIndex:indexPath.row];
    cell.wordIndex = (int)indexPath.row;
    cell.verse = self.verseInfo;
    cell.model = info;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    VerseWordTranslation* info = [self.words objectAtIndex:indexPath.row];
    
    return 80 + (info.syntaxAndMorphology.count + 1) * HEIGHT_OF_MORPHOLOGY_LABEL;
}

- (BOOL)hasSidebarButton {
    return NO;
}

- (IBAction)onClose:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UIColor*)getBackgroundTopColor {
    return  [[Theme instance] lightPageGradientTopColor];
}

- (UIColor*)getBackgroundBottomColor {
    return  [[Theme instance] lightPageGradientBottomColor];
}

@end
