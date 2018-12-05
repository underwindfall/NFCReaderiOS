import Foundation
import CoreNFC

class NFCHelper: NSObject, NFCNDEFReaderSessionDelegate {
  var onNFCResult: ((Bool, String) -> ())?
  func restartSession() {
    let session = NFCNDEFReaderSession(delegate: self, queue: nil, invalidateAfterFirstRead: false)
    session.begin()
  }
  
  // MARK: NFCNDEFReaderSessionDelegate
  func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
    guard let onNFCResult = onNFCResult else { return }
    onNFCResult(false, error.localizedDescription)
  }
  
  func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
    guard let onNFCResult = onNFCResult else { return }
    
    print("Detected NDEF")
    var payload = ""
    for message in messages {
      for record in message.records {
        print(record.identifier)
        print(record.payload)
        print(record.type)
        print(record.typeNameFormat)
        
        payload += "\(record.identifier)\n"
        payload += "\(record.payload)\n"
        payload += "\(record.type)\n"
        payload += "\(record.typeNameFormat)\n"
        
        
        if let resultString = String(data: record.payload, encoding: .utf8) {
          onNFCResult(true, resultString)
        }
      }
    }
  }
}
