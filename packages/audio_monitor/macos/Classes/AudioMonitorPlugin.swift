import Cocoa
import FlutterMacOS
import CoreAudio
import AudioToolbox

var globalEventSink: FlutterEventSink?

func audioQueueInputCallback(
    inUserData: UnsafeMutableRawPointer?,
    inAQ: AudioQueueRef,
    inBuffer: AudioQueueBufferRef,
    inStartTime: UnsafePointer<AudioTimeStamp>,
    inNumberPacketDescriptions: UInt32,
    inPacketDescs: UnsafePointer<AudioStreamPacketDescription>?
) {
    let audioData = inBuffer.pointee.mAudioData.assumingMemoryBound(to: Int16.self)
    let audioDataCount = Int(inBuffer.pointee.mAudioDataByteSize) / MemoryLayout<Int16>.size
    
    var sum: Int64 = 0
    for i in 0..<audioDataCount {
        sum += Int64(audioData[i]) * Int64(audioData[i])
    }
    let rms = sqrt(Double(sum) / Double(audioDataCount))
    let dB = 20.0 * log10(rms)

    print("Audio level: \(dB) dB")
    globalEventSink?(dB)
    
    AudioQueueEnqueueBuffer(inAQ, inBuffer, 0, nil)
}

public class AudioMonitorPlugin: NSObject, FlutterPlugin {
    var audioQueue: AudioQueueRef?
    var audioQueueBuffer = [AudioQueueBufferRef?](repeating: nil, count: 3)
    let sampleRate: Double = 44100
    let bufferDurationSeconds: Double = 0.1
    var resultCallback: FlutterResult?
    
    init(_ registrar: FlutterPluginRegistrar) {
        super.init()
    }
    
    // Register Flutter Method Channel and Event Channel
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "audio_monitor", binaryMessenger: registrar.messenger)
        let instance = AudioMonitorPlugin(registrar)
        registrar.addMethodCallDelegate(instance, channel: channel)
        
        let eventChannel = FlutterEventChannel(name: "audio_monitor_level", binaryMessenger: registrar.messenger)
        eventChannel.setStreamHandler(instance)
    }
    
    // Handle Method call
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
      switch call.method {
      case "getAudioDevices":
          result(getAudioDevices())
      case "startMonitoring":
          if let args = call.arguments as? [String: Any],
             let deviceId = args["deviceId"] as? Int {
              startMonitoring(deviceId: AudioDeviceID(deviceId))
              result("Monitoring started for device \(deviceId)")
          } else {
              result(FlutterError(code: "INVALID_ARGUMENT", message: "Device ID not provided", details: nil))
          }
      case "stopMonitoring":
          stopMonitoring()
          result("Monitoring stopped")
      default:
          result(FlutterMethodNotImplemented)
      }
    }
    
    func getAudioDevices() -> [[String: Any]] {
      var devices: [[String: Any]] = []

      var propertySize = UInt32(MemoryLayout<AudioDeviceID>.size)
      var audioDevicesCount: UInt32 = 0
      var propertyAddress = AudioObjectPropertyAddress(
          mSelector: kAudioHardwarePropertyDevices,
          mScope: kAudioObjectPropertyScopeGlobal,
          mElement: kAudioObjectPropertyElementMaster
      )

      var status = AudioObjectGetPropertyDataSize(
          AudioObjectID(kAudioObjectSystemObject),
          &propertyAddress,
          0,
          nil,
          &propertySize
      )
      if status != noErr {
          print("Error getting number of devices")
          return devices
      }

      audioDevicesCount = propertySize / UInt32(MemoryLayout<AudioDeviceID>.size)

      var audioDevices = [AudioDeviceID](repeating: 0, count: Int(audioDevicesCount))
      status = AudioObjectGetPropertyData(
          AudioObjectID(kAudioObjectSystemObject),
          &propertyAddress,
          0,
          nil,
          &propertySize,
          &audioDevices
      )
      if status != noErr {
          print("Error getting device list")
          return devices
      }

      for deviceID in audioDevices {
          var deviceName: CFString = "" as CFString
          var namePropertySize = UInt32(MemoryLayout<CFString>.size)
          var namePropertyAddress = AudioObjectPropertyAddress(
              mSelector: kAudioDevicePropertyDeviceNameCFString,
              mScope: kAudioObjectPropertyScopeGlobal,
              mElement: kAudioObjectPropertyElementMaster
          )

          status = AudioObjectGetPropertyData(
              deviceID,
              &namePropertyAddress,
              0,
              nil,
              &namePropertySize,
              &deviceName
          )
          if status == noErr {
              devices.append([
                  "id": Int(deviceID),
                  "name": deviceName as String
              ])
          }
      }

      return devices
    }


    func startMonitoring(deviceId: AudioDeviceID) {
        var audioFormat = AudioStreamBasicDescription(
            mSampleRate: sampleRate,
            mFormatID: kAudioFormatLinearPCM,
            mFormatFlags: kAudioFormatFlagIsSignedInteger | kAudioFormatFlagIsPacked,
            mBytesPerPacket: 2,
            mFramesPerPacket: 1,
            mBytesPerFrame: 2,
            mChannelsPerFrame: 1,
            mBitsPerChannel: 16,
            mReserved: 0
        )

        let bufferByteSize = UInt32(sampleRate * bufferDurationSeconds * Double(audioFormat.mBytesPerFrame))

        // Create a device property address to set the device
        var propertyAddress = AudioObjectPropertyAddress(
            mSelector: kAudioHardwarePropertyDefaultInputDevice,
            mScope: kAudioObjectPropertyScopeGlobal,
            mElement: kAudioObjectPropertyElementMaster
        )

        // Set the device
        var deviceID = deviceId
        let propertySize = UInt32(MemoryLayout<AudioDeviceID>.size)
        AudioObjectSetPropertyData(AudioObjectID(kAudioObjectSystemObject), &propertyAddress, 0, nil, propertySize, &deviceID)

        // Create audio queue
        AudioQueueNewInput(&audioFormat, audioQueueInputCallback, nil, nil, nil, 0, &audioQueue)

        // Allocate buffers
        for i in 0..<audioQueueBuffer.count {
            AudioQueueAllocateBuffer(audioQueue!, bufferByteSize, &audioQueueBuffer[i])
            AudioQueueEnqueueBuffer(audioQueue!, audioQueueBuffer[i]!, 0, nil)
        }

        // Start the queue
        AudioQueueStart(audioQueue!, nil)
    }

    func stopMonitoring() {
        if let audioQueue = audioQueue {
            AudioQueueStop(audioQueue, true)
            AudioQueueDispose(audioQueue, true)
        }
    }
}

// FlutterStreamHandlerプロトコルの実装
extension AudioMonitorPlugin: FlutterStreamHandler {
  public func onListen(withArguments arguments: Any?, eventSink: @escaping FlutterEventSink) -> FlutterError? {
      globalEventSink = eventSink
      return nil
  }

  public func onCancel(withArguments arguments: Any?) -> FlutterError? {
      globalEventSink = nil
      return nil
  }
}
