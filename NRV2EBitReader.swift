import Foundation

class NRV2EBitReader {
    
    enum GRGBitReaderError: Error {
        case dataUnavailable
    }
    
    private var data = [UInt8]()
    private var dataPosition: Int = 0
    private var currentByte: UInt8 = 0
    private var bitPosition: Int = 0
    
    init(data: [UInt8], startIndex: Int = 0) {
        self.data = data
        self.dataPosition = startIndex
    }
    
    var isDataAvailable: Bool {
        return dataPosition < data.count
    }
    
    func readBit() throws -> UInt8 {
        if !isDataAvailable {
            throw GRGBitReaderError.dataUnavailable
        }
        
        if bitPosition == 0 {
            currentByte = data[dataPosition] & (0xff)
            dataPosition += 1
            bitPosition = 8
        }
        
        bitPosition -= 1
        return ((currentByte >> bitPosition) & 1)
    }
    
    func readByte() throws -> UInt8 {
        if !isDataAvailable {
            throw GRGBitReaderError.dataUnavailable
        }
        
        let byte = data[dataPosition] & (0xff)
        dataPosition += 1
        return byte
    }
    
}
