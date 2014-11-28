/*
 Copyright 2014 OpenMarket Ltd
 
 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at
 
 http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */

#import "RoomMessageComponent.h"
#import "MatrixHandler.h"

NSString *const kLocalEchoEventIdPrefix = @"localEcho-";
NSString *const kFailedEventId = @"failedEventId";

@implementation RoomMessageComponent

- (id)initWithEvent:(MXEvent*)event andRoomState:(MXRoomState*)roomState {
    if (self = [super init]) {
        MatrixHandler *mxHandler = [MatrixHandler sharedHandler];
        
        // Build text component related to this event
        NSString* textMessage = [mxHandler displayTextForEvent:event withRoomState:roomState inSubtitleMode:NO];
        if (textMessage) {
            _textMessage = textMessage;
            _eventId = event.eventId;
            _height = 0;
            
            NSString *senderName = [roomState memberName:event.userId];
            _startsWithSenderName = ([textMessage hasPrefix:senderName] || [mxHandler isEmote:event]);
            
            // Set date time text label
            if (event.originServerTs != kMXUndefinedTimestamp) {
                _date = [NSDate dateWithTimeIntervalSince1970:event.originServerTs/1000];
            } else {
                _date = nil;
            }
            
            // Set display mode
            BOOL isIncomingMsg = ([event.userId isEqualToString:mxHandler.userId] == NO);
            if ([textMessage hasPrefix:kMatrixHandlerUnsupportedMessagePrefix]) {
                _status = RoomMessageComponentStatusUnsupported;
            } else if ([_eventId hasPrefix:kFailedEventId]) {
                _status = RoomMessageComponentStatusFailed;
            } else if (isIncomingMsg && ([textMessage rangeOfString:mxHandler.userDisplayName options:NSCaseInsensitiveSearch].location != NSNotFound || [textMessage rangeOfString:mxHandler.userId options:NSCaseInsensitiveSearch].location != NSNotFound)) {
                _status = RoomMessageComponentStatusHighlighted;
            } else if (!isIncomingMsg && [_eventId hasPrefix:kLocalEchoEventIdPrefix]) {
                _status = RoomMessageComponentStatusInProgress;
            } else {
                _status = RoomMessageComponentStatusNormal;
            }
        } else {
            // Ignore this event
            self = nil;
        }
    }
    return self;
}
@end

