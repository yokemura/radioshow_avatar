import Cocoa
import FlutterMacOS
import CoreAudio
import AudioToolbox

public class AudioMonitorPlugin: NSObject, FlutterPlugin {
    var audioQueue: AudioQueueRef?
    var audioQueueBuffer = [AudioQueueBufferRef?](repeating: nil, count: 3)
    let sampleRate: Double = 44100
    let bufferDurationSeconds: Double = 0.1
    var resultCallback: FlutterResult?
    
    init(_ registrar: FlutterPluginRegistrar) {
        super.init()
    }
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "audio_monitor", binaryMessenger: registrar.messenger)
        let instance = AudioMonitorPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "getPlatformVersion":
            result("macOS " + ProcessInfo.processInfo.operatingSystemVersionString)
        case "getAudioDevices":
            result(getAudioDevices())
        case "startMonitoring":
            startMonitoring()
            result("Monitoring started")
        case "stopMonitoring":
            stopMonitoring()
            result("Monitoring stopped")
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    func getAudioDevices() -> [String] {
      var devices: [String] = []

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
              devices.append(deviceName as String)
          }
      }

      return devices
    }

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

        AudioQueueEnqueueBuffer(inAQ, inBuffer, 0, nil)
    }

    func startMonitoring() {
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

        AudioQueueNewInput(&audioFormat, audioQueueInputCallback, nil, nil, nil, 0, &audioQueue)

        for i in 0..<audioQueueBuffer.count {
            AudioQueueAllocateBuffer(audioQueue!, bufferByteSize, &audioQueueBuffer[i])
            AudioQueueEnqueueBuffer(audioQueue!, audioQueueBuffer[i]!, 0, nil)
        }

        AudioQueueStart(audioQueue!, nil)
    }

    func stopMonitoring() {
        if let audioQueue = audioQueue {
            AudioQueueStop(audioQueue, true)
            AudioQueueDispose(audioQueue, true)
        }
    }
}
