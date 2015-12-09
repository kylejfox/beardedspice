//
//  RainwaveStrategy.m
//  BeardedSpice
//
//  Created by Kyle Fox on 12/8/15.
//  Copyright (c) 2015 Tyler Rhodes / Jose Falcon. All rights reserved.
//

#import "RainwaveStrategy.h"

@implementation RainwaveStrategy

- (id)init {
    self = [super init];
    if (self) {
        predicate =
            [NSPredicate predicateWithFormat:@"SELF LIKE[c] '*rainwave.cc/beta*'"];
    }
    return self;
}

- (BOOL)accepts:(TabAdapter *)tab {
    return [predicate evaluateWithObject:[tab URL]];
}

- (BOOL)isPlaying:(TabAdapter *)tab {

    NSNumber *value =
        [tab executeJavascript:@"(function(){return "
                               @"(document.querySelector('#r4_audio_player.playing') != null)}())"
         ];

    return [value boolValue];
}

- (NSString *)toggle {
    return @"(function(){\
        var event = new MouseEvent('click');\
        document.querySelector('svg.audio_icon_play').dispatchEvent(event)})()";
}

- (NSString *)pause {
    return @"(function(){\
        var e=document.querySelector('#r4_audio_player.playing');\
        if(e!=null){\
            var event = new MouseEvent('click');\
            document.querySelector('svg.audio_icon_play').dispatchEvent(event)}\
    })()";
}

- (NSString *)displayName {
    return @"Rainwave";
}

- (NSString *)favorite {
    return @"(function(){\
        var fave=document.querySelector('div.song.now_playing div.fave');\
        if(!fave.classList.contains('is_fave')){fave.click()}\
    })()";
}

- (Track *)trackInfo:(TabAdapter *)tab {
    
    NSDictionary *info = [tab
        executeJavascript:@"(function(){var track = document.querySelector('div.song.now_playing');\
            return {'track': track.querySelector('div.title').textContent,\
                'album': track.querySelector('div.album').textContent,\
                'artist': track.querySelector('div.artist').textContent,\
                'favorited': (track.querySelector('div.fave.is_fave') != null),\
                 'artURL': track.querySelector('div.art_expandable').style.getPropertyValue('background-image').slice(4,-1)}\
            })()"];

    Track *track = [Track new];

    [track setValuesForKeysWithDictionary:info];
    track.image = [self imageByUrlString:info[@"artURL"]];

    return track;
}

@end
