/*
 Copyright 2019 New Vector Ltd
 
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

import UIKit

@objcMembers
final class KeyVerificationConclusionBubbleCell: KeyVerificationBaseBubbleCell {
    
    // MARK: - Constants
    
    private enum Sizing {
        static let view = KeyVerificationConclusionBubbleCell(style: .default, reuseIdentifier: nil)
    }
    
    // MARK: - Setup
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        self.keyVerificationCellInnerContentView?.isButtonsHidden = true
        self.keyVerificationCellInnerContentView?.isRequestStatusHidden = true
    }
    
    // MARK: - Overrides
    
    override func render(_ cellData: MXKCellData!) {
        super.render(cellData)
        
        guard let keyVerificationCellInnerContentView = self.keyVerificationCellInnerContentView,
            let bubbleData = self.bubbleData,
            let viewData = self.viewData(from: bubbleData) else {
                NSLog("[KeyVerificationConclusionBubbleCell] Fail to render \(String(describing: cellData))")
                return
        }
        
        keyVerificationCellInnerContentView.badgeImage = viewData.badgeImage
        keyVerificationCellInnerContentView.title = viewData.title
        keyVerificationCellInnerContentView.updateSenderInfo(with: viewData.senderId, userDisplayName: viewData.senderDisplayName)
    }
    
    override class func sizingView() -> MXKRoomBubbleTableViewCell {
        return self.Sizing.view
    }
    
    // MARK: - Private
    
    // TODO: Handle view data filling
    private func viewData(from bubbleData: MXKRoomBubbleCellData) -> KeyVerificationConclusionViewData? {
        guard let event = bubbleData.bubbleComponents.first?.event else {
            return nil
        }
        
        let viewData: KeyVerificationConclusionViewData?
        
        let senderId = self.senderId(from: bubbleData)
        let senderDisplayName = self.senderDisplayName(from: bubbleData)
        let title: String?
        let badgeImage: UIImage?                
        
        switch event.eventType {
        case .keyVerificationDone:
            title = "Verified"
            badgeImage = Asset.Images.encryptionTrusted.image
        case .keyVerificationCancel:
            title = "Cancelled"
            badgeImage = Asset.Images.encryptionNormal.image
        default:
            badgeImage = nil
            title = nil
        }
        
        if let title = title, let badgeImage = badgeImage {
            viewData = KeyVerificationConclusionViewData(badgeImage: badgeImage,
                                                         title: title,
                                                         senderId: senderId,
                                                         senderDisplayName: senderDisplayName)
        } else {
            viewData = nil
        }
        
        return viewData
    }
}
