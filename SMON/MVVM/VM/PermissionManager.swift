import Foundation
import Contacts
import AVFoundation
import Photos

enum PermissionType {
    case contacts
    case camera
    case microphone
    case photos
}

class PermissionManager : ObservableObject {
    
    static let shared = PermissionManager()
    
    private init() {}
    
    func requestPermission(for type: PermissionType, completion: @escaping (Bool) -> Void) {
        switch type {
        case .contacts:
            requestContactsPermission(completion: completion)
        case .camera:
            requestCameraPermission(completion: completion)
        case .microphone:
            requestMicrophonePermission(completion: completion)
        case .photos:
            requestPhotosPermission(completion: completion)
        }
    }
    
    private func requestContactsPermission(completion: @escaping (Bool) -> Void) {
        CNContactStore().requestAccess(for: .contacts) { (granted, error) in
            completion(granted)
        }
    }
    
    private func requestCameraPermission(completion: @escaping (Bool) -> Void) {
        AVCaptureDevice.requestAccess(for: .video) { (granted) in
            completion(granted)
        }
    }
    
    private func requestMicrophonePermission(completion: @escaping (Bool) -> Void) {
        AVAudioSession.sharedInstance().requestRecordPermission { (granted) in
            completion(granted)
        }
    }
    
    private func requestPhotosPermission(completion: @escaping (Bool) -> Void) {
        PHPhotoLibrary.requestAuthorization { (status) in
            completion(status == .authorized)
        }
    }
    
    func getPermissionStatus(for type: PermissionType) -> Bool {
        switch type {
        case .contacts:
            return CNContactStore.authorizationStatus(for: .contacts) == .authorized
        case .camera:
            return AVCaptureDevice.authorizationStatus(for: .video) == .authorized
        case .microphone:
            return AVAudioSession.sharedInstance().recordPermission == .granted
        case .photos:
            return PHPhotoLibrary.authorizationStatus() == .authorized
        }
    }
}
