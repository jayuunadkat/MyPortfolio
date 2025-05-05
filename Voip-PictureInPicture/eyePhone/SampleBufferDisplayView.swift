//
//  SampleBufferDisplayView.swift
//  eyePhone
//
//  Created by Jaymeen Unadkat on 05/05/25.
//

import UIKit
import AVKit

final class SampleBufferDisplayView: UIView {

    override class var layerClass: AnyClass {
        AVSampleBufferDisplayLayer.self
    }

    var sampleBufferDisplayLayer: AVSampleBufferDisplayLayer {
        layer as! AVSampleBufferDisplayLayer
    }
}
